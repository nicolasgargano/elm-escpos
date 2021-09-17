# Tickets Preview

## Prerequisites

-   Docker: to run `docker-compose`

_Docker is necessary to run the `esc2html` util from [escpos-tools](https://github.com/receipt-print-hq/escpos-tools),
which is a server that can receive requests with escpos commands and return html. 
If you know of a more straightforward way of converting to html, please let me know._

## Running

-   Run `npm start`
-   Go to http://localhost:3500

## Adding your own tickets

In [Tickets.elm](src/Tickets.elm) you'll find `allTickets` with the sample tickets, 
add your own to that list and they will appear in the sidebar of the preview app.

Vite should hot-reload the preview app with your changes.