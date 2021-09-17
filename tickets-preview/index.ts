// @ts-ignore vite will take care of this
import { Elm } from "./src/TicketPreview.elm"

const init = async () => {
    const flags = { ticketRendererEndpoint: "http://localhost:8001/" }
    const app = Elm.TicketPreview.init({ flags })

    app.ports.connectAndPrint.subscribe(connectAndPrint)
}

const connectAndPrint = async (ints: Array<number>) => {
    console.info("Connect & Print", ints)

    // Ask user for printer
    const selectedDevice: USBDevice = await navigator.usb.requestDevice({
        filters: []
    })

    // Setup
    await selectedDevice.open()
    await selectedDevice.selectConfiguration(1)
    await selectedDevice.claimInterface(0)

    // Send to printer
    const uintsArray = new Uint8Array(ints)
    selectedDevice.transferOut(1, uintsArray)
}

init()
