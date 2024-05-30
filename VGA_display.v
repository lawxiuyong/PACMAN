module vga (
   input clk100_i,
   output vga_hs_o,
   output vga_vs_o,
   output [3:0] vga_red,
   output [3:0] vga_green,
   output [3:0] vga_blue
);
  
    //internal signals
    wire           vga_clk;
    reg [23:0]     vga_pix_x = 0;
    reg [23:0]     vga_pix_y = 0;
    reg            vga_hs;
    reg            vga_vs;
    
    //VGA timing parameters
    localparam     VGA_X_SIZE   = 1650;
    localparam     VGA_Y_SIZE   = 750;
    localparam     VGA_HS_BEGIN = 1390;
    localparam     VGA_HS_SIZE  =  40;
    localparam     VGA_VS_BEGIN = 725;
    localparam     VGA_VS_SIZE  =   5;
    localparam     VGA_X_PIXELS = 1280;
    localparam     VGA_Y_PIXELS = 720;
    
    //clock wizard
    clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(vga_clk),     // output clk_out1
   // Clock in ports
    .clk_in1(clk100_i)      // input clk_in1
    );
    
    //horizontal pixel counter
    always @ (posedge vga_clk)
    begin
       if (vga_pix_x == VGA_X_SIZE-1) begin
          vga_pix_x <= 0;
       end else begin
          vga_pix_x <= vga_pix_x + 1;
       end
    end
    
    //vertical pixel counter
    always @ (posedge vga_clk)
    begin
       if (vga_pix_x == VGA_X_SIZE-1) begin
          if (vga_pix_y == VGA_Y_SIZE-1) begin
             vga_pix_y <= 0;
          end else begin
             vga_pix_y <= vga_pix_y + 1;
          end
       end
    end
    
    always @ (posedge vga_clk)
    begin
        //horizontal sync
        vga_hs <= 1'b0;
        if (vga_pix_x >= VGA_HS_BEGIN && vga_pix_x < VGA_HS_BEGIN + VGA_HS_SIZE) begin
          vga_hs <= 1'b1;
        end
        
        //vertical sync
        vga_vs <= 1'b0;
        if (vga_pix_y >= VGA_VS_BEGIN && vga_pix_y < VGA_VS_BEGIN + VGA_VS_SIZE) begin
          vga_vs <= 1'b1;
        end
        
        //color signal
        //vga_col <= 0;
        //if (vga_pix_x < VGA_X_PIXELS && vga_pix_y < VGA_Y_PIXELS) begin
          //vga_col <= vga_pix_x[8:1] ^ vga_pix_y[8:1];
          //end
    end
    
    assign vga_hs_o  = vga_hs;
    assign vga_vs_o  = vga_vs;
    
    //color signal
    assign vga_red = (vga_pix_x < 1540 && vga_pix_x > 259 && vga_pix_y < 745 && vga_pix_y > 24) ? 4'hF:4'h0;
    assign vga_green = (vga_pix_x < 1540 && vga_pix_x > 259 && vga_pix_y < 745 && vga_pix_y > 24) ? 4'hF:4'h0;
    assign vga_blue = (vga_pix_x < 1540 && vga_pix_x > 259 && vga_pix_y < 745 && vga_pix_y > 24) ? 4'hF:4'h0;

endmodule
