'use strict';

const torrentStream = require('torrent-stream');
const path = require('path');
const fs = require('fs');
const ffmpeg = require('fluent-ffmpeg');
const express = require('express');
const app = express();
const axios = require('axios');
const localdownload = '/tmp/hypertube/torrents/';
const downloadpath = '/tmp/hypertube/movies/';

const options = {
    path: '/tmp/hypertube/torrent-stream',
    verify: true,
    connections: 1000,
    uploads: 1000
};

var engineTorrent = [];

const ext = [
    'mp4',
    'webm',
    'mkv',
    'avi',
    'ogg',
    'mpg',
    'flv',
    'wmv',
    'mov',
    'f4v',
    'f4p'
];

function downloadVideo (strucData) {
    console.warn(strucData['hash'], strucData['quality'])

    if (engineTorrent[strucData.hash]) {
        strucData.express.res.sendStatus(200)
    } else {

        var buff = null;
        if (strucData['magnet'] != null)
            buff = strucData['magnet']
        else if (fs.existsSync(localdownload + strucData.hash + '.torrent')) {
            buff = fs.readFileSync(localdownload + strucData.hash + '.torrent')
        } else {
            strucData.express.res.sendStatus(404)
            return false
        }

        engineTorrent[strucData.hash] = torrentStream(buff, options);

        engineTorrent[strucData.hash].on('ready', function() {

            engineTorrent[strucData.hash].files.forEach(function(file) {

                if (!(ext.includes(path.extname(file.name).substring(1)))) {
                    file.deselect
                } else {
                    file.select
                    strucData['extension'] = path.extname(file.name);
                    strucData['stream'] = file.createReadStream();
                    strucData['path'] = file.path
                    strucData['length'] = file.length

                    axios.post('http://localhost:3000/torrent/data', {'token': strucData.token, 'filesize': file.length, 'path': file.path, 'completed': 0})

                    if (strucData['extension'] == '.mp4' || strucData['extension'] == '.webm') {
                    	var steamdirect = fs.createWriteStream(downloadpath + strucData.hash + '.webm', {end: true})
                    	strucData['stream'].pipe(steamdirect)
                    } else {

	                    ffmpeg(strucData['stream'])
	                        .videoCodec('libvpx')
	                        .audioCodec('libvorbis')
	                        .outputOption(
	                            '-deadline realtime'
	                        )
	                        .audioBitrate('128')
	                        .videoBitrate(1000)
	                        .format('webm')
	                        .on('error', function(error) {
	                            console.log('Movie convert error')
	                        }).save(downloadpath + strucData.hash + '.webm', { end: true });
                    }
                }
            });

            engineTorrent[strucData.hash].on('download', function (pices) {
                console.log('PIECES  DL  :    ' + strucData.hash, pices)
                if (strucData.count == 100) {
                    strucData.express.res.sendStatus(201)
                }
                strucData.count = strucData.count + 1
            })

        });

    }
}

function streamVideo (strucData) {

    if (fs.existsSync(downloadpath + strucData.hash + '.webm')) {

        const fileSize = strucData.file.filesize
        const range = strucData.express.req.headers.range
        if (range) {
            const parts = range.replace(/bytes=/, "").split("-")
            const start = parseInt(parts[0], 10)
            const end = parts[1]
                ? parseInt(parts[1], 10)
                : fileSize-1
            const chunksize = (end-start)+1
            const file = fs.createReadStream(downloadpath + strucData.hash + '.webm', {start, end})
            const head = {
                'Content-Range': `bytes ${start}-${end}/${fileSize}`,
                'Accept-Ranges': 'bytes',
                'Content-Length': chunksize,
                'Content-Type': 'video/mp4',
            }
            strucData.express.res.writeHead(206, head);
            file.pipe(strucData.express.res);
        } else {
            const head = {
                'Content-Length': fileSize,
                'Content-Type': 'video/mp4',
            }
            strucData.express.res.writeHead(200, head)
            fs.createReadStream(downloadpath + strucData.hash + '.webm').pipe(strucData.express.res)
        }

        console.log('START STREAM', strucData.hash)

    } else {
        strucData.express.res.sendStatus(404)
    }
}

app.get('/download/:auth', function(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,contenttype');

    var strucData = {
        'hash': null,
        'quality': 0,
        'extension': null,
        'stream': null,
        'path': null,
        'count': 0,
        'token': req.params.auth,
        'express': {
            'req': req,
            'res': res
        },
        file: null,
        magnet: null
    };

    axios.get('http://localhost:3000/torrent/auth/download/' + req.params.auth).then((response) => {
        strucData['hash'] = response.data.data.torrent_id.toLowerCase();
        strucData['quality'] = response.data.data.quality.replace('p','');
        strucData['magnet'] = response.data.data.magnet;

        downloadVideo(strucData);

    }).catch(() => {
        res.sendStatus(401);
    })
});

app.get('/stream/:auth', function(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,contenttype');

    var strucData = {
        'hash': null,
        'quality': 0,
        'extension': null,
        'stream': null,
        'path': null,
        'express': {
            'req': req,
            'res': res
        },
        file: null
    };

    axios.get('http://localhost:3000/torrent/auth/stream/' + req.params.auth).then((response) => {
        strucData['hash'] = response.data.data.torrent_id.toLowerCase();
    strucData['quality'] = response.data.data.quality.replace('p','');
    strucData['file'] = response.data.file

    if (strucData['file'])
        streamVideo(strucData);
    else
        res.sendStatus(404)

}).catch(() => {
        res.sendStatus(401);
})
});

app.listen(8080, function () {
    console.log('TorrentStream is OK')
})
