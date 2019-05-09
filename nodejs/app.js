const worker  = require('commander');
const redis   = require('redis')
const request = require('request')

if (!process.env.REDIS_URL) throw new Error("Please set REDIS_URL")

const REDIS_URL = process.env.REDIS_URL;

worker
    .version("1.0.0")
    .command("worker")
    .action(function(cmd, options){

        subscribe = redis.createClient(REDIS_URL);
        client = redis.createClient(REDIS_URL);

        console.log(`Start listening for tasks on ${REDIS_URL}`);

        subscribe.on("message", (channel, msg_raw)=>{
            msg = JSON.parse(msg_raw);
            console.log(msg)
            console.log(msg_raw)

            request.get(`https://en.wikipedia.org/w/api.php?action=query&list=search&srwhat=text&srprop=timestamp&continue=&format=json&srsearch=${msg.search}`,
                (err, response, body) => {
                    client.set(msg.job_id, JSON.stringify(JSON.parse(body)['query']))
                    console.log(body)
                    console.log(JSON.stringify(JSON.parse(body)['query']))
                    console.log(msg.job_id)
                }
            )
        });

        subscribe.subscribe("jobs");
    })

worker.parse(process.argv)
