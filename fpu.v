// さのくん
module normalize(
    input [31:0] kekka,
    output [31:0] res
);
// 正規化などをする


// 最終的にはこういう感じでresに代入する
assign res = hoge;

endmodule

// 盛くん
module add(
    input [26:0] lar,
    input [26:0] sma,
    input oror,
    output [31:0] res
);

wire [31:0] kekka;

// 普通に足し算
// 丸めもする

// 一緒だったらー

// outputは、足し算した結果を23bitにまるめたもの。しかし、正規化や2進に治すことはしなくていい

normalize normalize(.kekka(kekka), .res(res));

endmodule

// 阪本くん担当
module calladd(
    input [30:0] l,
    input [30:0] s,
    input L,
    input S,
    input [7:0] d,
    input oror,
    output [31:0] res
);

wire [26:0] la;
wire [300:0] sm;

// 上下2bit拡張
assign la = (|l==1'b0) ? {2'b00,l[22:0],2'b00} : {2'b01,l[22:0],2'b00};
assign sm = (|s==1'b0) ? {2'b00,s[22:0],276'b0} : {2'b01,s[22:0],276'b0};

wire [300:0] shiftsm;
wire orwotoru;

// 小さい方をシフト
assign shiftsm = sm >> d;
assign orwotoru = |sm[273:0];

wire [26:0] lar;
wire [26:0] sma;

// 負の数ならば補数に変換
always @(L or S or la or shiftsm) begin
	if(L==1'b1) begin
		lar <= ~l + 1'b1;
	end else begin
		lar <= l;
	end
	if(S==1'b1) begin
		sma <=(~sm[300:274]) + 1'b1;
	end else begin
		sma <= sm[300:274];
	end
end

add add(.lar(lar), .sma(sma), .oror(oror) .res(res) )
endmodule

module compare(
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
);

    wire [30:0] l,
    wire [30:0] s,
    wire L,
    wire S,
    wire [31:0] d;
    wire oror;
if (a[30:23] > b[30:23]) begin
        assign l = a[30:0];
        assign s = b[30:0];
        assign L = a[31];
        assign S = b[31];
        assign d = a[30:23] - b[30:23]
    end
else if (a[30:23] < b[30:23]) begin
        assign l = b[30:0];
        assign s = a[30:0];
        assign L = b[31];
        assign S = a[31];
        assign d = b[30:23] - a[30:23]
    end
else if(a[22:0] > b[22:0]) begin
        assign l = a[30:0];
        assign s = b[30:0];
        assign L = a[31];
        assign S = b[31];
        assign d = a[30:23] - b[30:23]
    end
else if (a[22:0] < b[22:0]) begin
        assign l = b[30:0];
        assign s = a[30:0];
        assign L = b[31];
        assign S = a[31];
        assign d = b[30:23] - a[30:23]
    end
// ここは適当
else if (a[22:0] == b[22:0]) begin
        assign l = b[30:0];
        assign s = a[30:0];
        assign L = b[31];
        assign S = a[31];
        assign d = a[30:23] - b[30:23]
    end 

calladd calladd(.oror(oror), .l(l), .s(s), .L(L), .S(S), .d(d), .res(res))
endmodule
