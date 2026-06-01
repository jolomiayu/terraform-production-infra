require('dotenv').config();

const http = require('http');
const { Client } = require('pg');

const client = new Client({

    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: 5432,
    ssl: {
        rejectUnauthorized: false
    }
});

client.connect()
    .then(async () => {

        console.log('Connected to PostgreSQL');

        await client.query(`
            CREATE TABLE IF NOT EXISTS bookings (
                id SERIAL PRIMARY KEY,
                customer_name TEXT,
                service TEXT,
                appointment_date TEXT,
                status TEXT DEFAULT 'Pending'
            )
        `);

        console.log('Bookings table ready 🚀');

    })

    .catch(err =>
        console.error(
            'Database connection error',
            err
        )
    );

const server = http.createServer(async (req, res) => {

    res.setHeader('Access-Control-Allow-Origin', '*');

    res.setHeader(
        'Access-Control-Allow-Methods',
        'GET, POST, DELETE'
    );

    res.setHeader(
        'Access-Control-Allow-Headers',
        'Content-Type'
    );

    try {

        if (
            req.url === '/bookings' &&
            req.method === 'GET'
        ) {

            const result =
                await client.query(
                    'SELECT * FROM bookings ORDER BY id DESC'
                );

            res.writeHead(200, {
                'Content-Type': 'application/json'
            });

            res.end(JSON.stringify(result.rows));
        }

        else if (
            req.url === '/bookings' &&
            req.method === 'POST'
        ) {

            let body = '';

            req.on('data', chunk => {
                body += chunk.toString();
            });

            req.on('end', async () => {

                const data = JSON.parse(body);

                await client.query(
                    `
                    INSERT INTO bookings
                    (
                        customer_name,
                        service,
                        appointment_date
                    )
                    VALUES ($1, $2, $3)
                    `,
                    [
                        data.customer_name,
                        data.service,
                        data.appointment_date
                    ]
                );

                res.writeHead(201, {
                    'Content-Type': 'application/json'
                });

                res.end(JSON.stringify({
                    message:
                        'Booking created successfully 🚀'
                }));
            });
        }

        else if (
            req.url.startsWith('/bookings/') &&
            req.method === 'DELETE'
        ) {

            const id =
                req.url.split('/')[2];

            await client.query(
                'DELETE FROM bookings WHERE id = $1',
                [id]
            );

            res.writeHead(200, {
                'Content-Type': 'application/json'
            });

            res.end(JSON.stringify({
                message:
                    'Booking deleted successfully'
            }));
        }

        else {

            res.writeHead(200, {
                'Content-Type': 'application/json'
            });

            res.end(JSON.stringify({
                message:
                    'Salon Backend + PostgreSQL Running 🚀'
            }));
        }

    }

    catch (error) {

        console.error(error);

        res.writeHead(500, {
            'Content-Type': 'application/json'
        });

        res.end(JSON.stringify({
            error: 'Internal Server Error'
        }));
    }

});

server.listen(3000, () => {

    console.log(
        'Server running on port 3000'
    );

});
