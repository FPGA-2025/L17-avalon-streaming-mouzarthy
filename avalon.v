module avalon (
    input wire clk,
    input wire resetn,
    output reg valid,
    input wire ready,
    output reg [7:0] data
);

reg [2:0] current_state, next_state;

parameter IDLE      = 3'b000;
parameter STATE_4   = 3'b001;
parameter STATE_5   = 3'b010;
parameter STATE_6   = 3'b011;

reg [7:0] data_reg;
reg valid_reg; 

always @(posedge clk or negedge resetn) 
begin
    if(!resetn) 
    begin
        current_state <= IDLE;
        valid_reg <= 1'b0;
    end 
    else 
    begin
        current_state <= next_state;
        valid_reg <= valid;
    end
end

always @(*) begin
    
    next_state = current_state;
    valid = valid_reg;
    data = 8'h00; 

    case(current_state)
        IDLE: 
        begin
            if(ready) 
            begin
                next_state = STATE_4;
                valid = 1'b0;
                data_reg = 8'h4;
            end 
            else 
            begin
                next_state = IDLE;
                valid = 1'b0;
            end
        end
        STATE_4: 
        begin
            next_state = STATE_5;
            data = data_reg;
            data_reg = 8'h5;
        end
        STATE_5: 
        begin
            next_state = STATE_6;
            data = data_reg;
            data_reg = 8'h6;
        end
        STATE_6: 
        begin
            next_state = STATE_4;
            data = data_reg;
            data_reg = 8'h4;
        end
        default: 
        begin
            next_state = IDLE;
            valid = 1'b0;
            data = 8'h00;
        end
    endcase
end

endmodule

