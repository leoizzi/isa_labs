class packet_in extends uvm_sequence_item;
    rand integer A;
    rand integer B;
	
    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(A, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(B, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end
	
	constraint my_const {
			(((A & 32'h7f800000)>>23) + ((B & 32'h7f800000)>>23) - 127) > 0;
			(((A & 32'h7f800000)>>23) + ((B & 32'h7f800000)>>23) - 127) < 253;
			((A & 32'h7f800000)>>23) > 0;
			((A & 32'h7f800000)>>23) < 255;
			((B & 32'h7f800000)>>23) > 0;
			((B & 32'h7f800000)>>23) < 255;
	}

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_in
