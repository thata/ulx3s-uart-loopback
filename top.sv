// UART ループバック回路
module top(
    input clk,
    input rx,
    output tx,
    output wifi_gpio0
);
    wire transmit;              // Signal to start transmission
    wire received;              // Signal indicating a byte is received
    wire is_receiving;          // Indicates receiving status
    wire is_transmitting;       // Indicates transmitting status
    wire recv_error;            // Receive error indicator
    wire [7:0] rx_byte;         // Received byte
    reg [7:0] tx_byte;          // Byte to transmit
    reg tx_trigger;             // Transmission trigger

    uart uart_inst (
        .clk(clk),
        .rst(1'b0),
        .rx(rx),
        .tx(tx),
        .transmit(tx_trigger),
        .tx_byte(tx_byte),
        .received(received),
        .rx_byte(rx_byte),
        .is_receiving(is_receiving),
        .is_transmitting(is_transmitting),
        .recv_error(recv_error)
    );

    // RX から受信したデータを TX へループバックする
    always @(posedge clk) begin
        if (received) begin
            tx_byte <= rx_byte;
            tx_trigger <= 1'b1;
        end else if (tx_trigger) begin
            tx_trigger <= 1'b0;
        end
    end

  // 理由を忘れたけど wifi_gpio0 のフラグを立てておく必要がある
  assign wifi_gpio0 = 1'b1;
endmodule

