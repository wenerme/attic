'//////////////////////////
'////////��ԭde������//////
'////////����id:a3160586///
'////////����:Wener////////
'////////=================/
'////////��ӭ����//////////
'////////club.eebbk.com////
'//////////////////////////
'//һЩ�ַ��Ķ���
const Cal_Code_Cencle = &h43

const Cal_Code_Div = &h2f
const Cal_Code_Mul = &h2a
const Cal_Code_Sub = &h2d
const Cal_Code_Add = &h2b
const Cal_Code_Equ = &h3d

const Cal_Code_MR = &h52
const Cal_Code_MC = &h41
const Cal_Code_M = &h4d

const Cal_Code_ZF = &h5f
const Cal_Code_Flo = &h2e

const Cal_Code_Esc = &h45
const Cal_Code_Del = &h3c

'==//�����ʹ���
dim Cal_key_up ,Cal_key_down, Cal_key_left, Cal_key_right, Cal_key_enter, Cal_key_escape
dim Cal_User_Inkey, Cal_touch_x, Cal_touch_y, Cal_touch_id

'==//ͼƬ���
dim cal_pic_KB, cal_pic_KB_pr
dim cal_pic_Num, cal_pic_S

dim cal_page_Catch
'==//����
dim cal_op_1!, cal_operator, cal_CurOperator, cal_op_2!, cal_Op_cur$, cal_op_state, cal_op_re!
dim cal_CurStr$, cal_CurChar, cal_LastChar
dim cal_spc_equ
'==//����
dim cal_data_KB$, cal_data_m$ 'Mֵ��M��״̬
dim cal_data_m_State
dim cal_sys_state
dim Cal_Show_Pic_X, Cal_Show_Pic_Y
dim Cal_Show_Pic_Wid '��Ҫ��=Ҫռ3λ

dim Cal_Pr_Recover, Cal_tick
dim Cal_fe$, Cal_The
declare function Cal_Calculator( Cal_p_The)

declare function Cal_getInput()
declare function Cal_calTouchId()
declare function Cal_Pickchar$()
declare function Cal_input_test()
declare function Cal_Show()

declare function str2float!( str2float_p_fstr$)
declare function float2str$( float2str_p_flo!)
declare function ShowFloat( ShowFloat_p_hPage, ShowFloat_p_hImg, ShowFloat_p_x, ShowFloat_p_y, ShowFloat_p_Float$)

'//////=====����������=====//////////
setlcd( 240, 320)
Cal_Calculator(0)

function Cal_Calculator( Cal_p_The)

if Cal_p_The then
Cal_The = 4
else
Cal_The = 0
end if

IF GetEnv!() = Env_SIM Then
	Cal_fe$ = "calculator_res.rlb"
Else
	Cal_fe$ = "calculator_res.lib"
End IF
'==//��ʼ��
cal_pic_KB = loadres( Cal_fe$, 1 + Cal_The )
cal_pic_KB_pr = loadres( Cal_fe$, 2 + Cal_The)

cal_pic_Num = loadres( Cal_fe$, 3 + Cal_The)
cal_pic_S = loadres( Cal_fe$, 4 + Cal_The)

cal_page_Catch = createpage()


cal_data_KB$ = "C789/M456*R123-A_.0+E===<"
cal_Op_cur$ = "0"
showpic( -1, cal_pic_KB, 0, 0, 240, 320, 0, 0, 1)

cal_op_state = 1
cal_sys_state = 1
Cal_Show()
while cal_sys_state
Cal_User_Inkey = inkey()
Cal_tick = gettick()
Cal_getInput()

'==//��������ʱ�ָ�
if ( Cal_tick - Cal_Pr_Recover) > 40 and Cal_Pr_Recover then
	
	'==//������ֻ��ָ�һ��ģ�������С�����ܰ��ĺܿ죬���ºܶ�ָ�����
	showpic( -1, cal_pic_KB, 0, 67, 240, 253, 0, 67, 0)
	Cal_Pr_Recover = 0
end if

'==//��������
if Cal_touch_id > - 1 then
	
	Cal_Pickchar$() '==//��һ���Ժ� cal_CurStr$, cal_CurChar ����ֵ
	cal_Op_cur_len = len( cal_Op_cur$) '==//�������õ�����������
	
	'===//�Ƿ�������Ĳ���
	if Cal_input_test() then
	
	'===//�����ֵ�ʱ��
	else if cal_CurChar > 47 and cal_CurChar < 58 or ( cal_CurChar = Cal_Code_Flo and instr( 0, ".", cal_Op_cur$) < 1 ) then
	
	if cal_Op_state = 2 then
	cal_Op_state = 3
	
	else if cal_Op_state = 4 then
	cal_Op_cur$ = "0"
	cal_Op_state = 5
	end if
	
		if cal_Op_cur$ = "0" and cal_CurChar <> asc( ".") then
			cal_Op_cur$ = cal_CurStr$
		else
			cal_Op_cur$ = cal_Op_cur$ + cal_CurStr$
		end if
	
	'===//ȡ��
	else if cal_CurChar = Cal_Code_Cencle then
		cal_Op_cur$ = "0"
		cal_op_1! = 0
		cal_op_2! = 0
		cal_op_re! = 0
		cal_Op_state = 1
		cal_CurOperator = 0
	'===//����
	else if cal_CurChar = Cal_Code_ZF then
		
		if mid$( cal_Op_cur$, 0, 1) = "-" then
			cal_Op_cur$ = right$( cal_Op_cur$, cal_Op_cur_len - 1)
		'====//��Ϊ0
		else if cal_Op_cur$ <> "0" then
			cal_Op_cur$ = "-" + cal_Op_cur$
		end if
	'===//ɾ�����һλ
	else if cal_CurChar = Cal_Code_Del then
		'====//ֻ��һλ��ʱ��
		cal_Op_state = 1
		if cal_Op_cur_len = 1 then
			cal_Op_cur$ = "0"
		else
			cal_Op_cur$ = mid$( cal_Op_cur$, 0, cal_Op_cur_len - 1)
		end if
	'==//���� ���������ڵ�ʱ�������һ�μ���
	else if cal_CurChar = Cal_Code_Equ then
		cal_CurOperator = Cal_Code_Equ
		cal_Op_state = 3
		
		'cal_Op_cur$ = float2str$( cal_op_2!)
		vasm(" call Cal_Calculate:")
		
	'==//������Щ��������Ч������һ����
	else if cal_LastChar = cal_CurChar then
	
	'==//��
	else if cal_CurChar = Cal_Code_Add then

		cal_CurOperator = Cal_Code_Add
		
		vasm(" call Cal_Calculate:")
		
	'==//��
	else if cal_CurChar = Cal_Code_Sub then
		
		cal_CurOperator = Cal_Code_Sub
	
		vasm(" call Cal_Calculate:")
		

		'cal_CurOperator = Cal_Code_Sub
	'==//��
	else if cal_CurChar = Cal_Code_Div then
		
		cal_CurOperator = Cal_Code_Div
		
		vasm(" call Cal_Calculate:")
	'==//��
	else if cal_CurChar = Cal_Code_Mul then
			
		cal_CurOperator = Cal_Code_Mul
		vasm(" call Cal_Calculate:")

	'==//M
	else if cal_CurChar = Cal_Code_M then
		cal_data_m$ = cal_Op_cur$
		cal_data_m_State = 1
	'==//MC
	else if cal_CurChar = Cal_Code_MC then
		cal_data_m_State = 0	
	'==//MR
	else if cal_CurChar = Cal_Code_MR then
		cal_Op_cur$ = cal_data_m$
	end if

	Cal_Show()
	
end if

cal_LastChar = cal_CurChar

'==//�˳�
if cal_CurChar = Cal_Code_Esc or Cal_key_escape then
	cal_sys_state = 0
END IF
wend

'==//�ͷ���Դ
deletepage( cal_page_Catch)
freeres( cal_pic_KB_pr)
freeres( cal_pic_Num)
freeres( cal_pic_KB)
freeres( cal_pic_S)

end function
'////////=========�������嶨��==========/////////
'//����id
function Cal_calTouchId()

'==//����������Ч������
if cal_touch_y < 64 then

else

cal_touch_y = cal_touch_y - 67

Cal_Show_Pic_Y = cal_touch_y / 51

Cal_Show_Pic_X = cal_touch_x / 48


Cal_touch_id = Cal_Show_Pic_Y * 5 + Cal_Show_Pic_X

'===//����һ��
if Cal_touch_id > 20 and Cal_touch_id < 24 then
	Cal_Show_Pic_X = 1
	Cal_Show_Pic_Wid = 48 * 3
else
	Cal_Show_Pic_Wid = 48
end if
showpic( -1, cal_pic_KB_pr, Cal_Show_Pic_X * 48, Cal_Show_Pic_Y * 51 + 67, Cal_Show_Pic_Wid, 48, Cal_Show_Pic_X * 48, Cal_Show_Pic_Y * 51 + 67, 0)
Cal_Pr_Recover = gettick()
end if

end function

'//��ȡ����ĺ���
function Cal_getInput()

'==/////===========����
if Cal_User_Inkey < 0 then
	Cal_touch_x = getpenposx( Cal_User_Inkey)
	Cal_touch_y = getpenposy( Cal_User_Inkey)
	Cal_touch_id = -1
	
	Cal_calTouchId() '���㴥��
	
else
	Cal_touch_x = -1
	Cal_touch_y = -1
	Cal_touch_id = -1
end if
'==/////=========== �����
VASM("LD INT r3,38") '//==UP
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_key_up],r3")

VASM("LD INT r3,40") '//==DOWN
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_Key_Down],r3")

VASM("LD INT r3,37") '//==left
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_Key_Left],r3")

VASM("LD INT r3,39") '//==right
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_Key_Right],r3")
'//==============������
VASM("LD INT r3,13") '//==ENTER
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_Key_Enter],r3")

VASM("LD INT r3,27") '//==ESCAPE
VASM("OUT 34,0")
VASM("LD INT [VINT_Cal_Key_Escape],r3")

end function

'==//��ȡ�ַ�
function Cal_Pickchar$()

cal_CurStr$ = mid$( cal_data_KB$, Cal_touch_id, 1)
cal_CurChar = asc( cal_CurStr$)

end function

'//���Ǻܵ��۵��߼������Ǹ�ȥ������
'//Ϊ�˺�bdaһ����Ч�������Ժ�tmd��~~
'//ɱ����������ϸ����
function Cal_input_test()

dim shared Cal_input_test_re, Cal_input_test_flo, Cal_input_minus

Cal_input_test_re = 0

'==//ֻ�е������ڴ���10 ��ʱ��Ų���
if cal_Op_cur_len > 10 then

'==//ֻ�е������ֻ�����С�����ʱ��Ų���
if cal_CurChar > 47 and cal_CurChar < 58 or cal_CurChar = Cal_Code_Flo then

Cal_input_test_flo = instr( 0, ".", cal_Op_cur$)
if Cal_input_test_flo > 0 then

	cal_Op_cur_len = cal_Op_cur_len - 1
end if


if mid$( cal_Op_cur$, 0, 1) = "-" then
	'Cal_input_minus = 1
	cal_Op_cur_len = cal_Op_cur_len - 1
else
	Cal_input_minus = 0
end if

if cal_Op_cur_len = 11 then
	Cal_input_test_re = 1
end if

end if
end if

Cal_input_test = Cal_input_test_re
end function

'//strtofloat ���ַ���ת��Ϊ������
function str2float!( str2float_p_fstr$)
dim shared str2float_fstr$

str2float_fstr$ = str2float_p_fstr$

asm
ld int r3, [ vstr_str2float_fstr]
in [ rb ], 11
endasm

end function

'//float2str ���ַ���ת��Ϊ������
'//һ����΢���Ƶĺ���~~~
function float2str$( float2str_p_flo!)
dim shared float2str_re$, float2str_flo!, float2str_int, float2str_i, float2str_rint$
dim shared float2str_cur$,  float2str_fint!

float2str_flo! = float2str_p_flo!
float2str_int = float2str_flo!

float2str_re$ = str$( float2str_int)

if float2str_int = float2str_flo! then
	float2str$ = float2str_re$
	vasm(" jmp fstr_float2str_exit")
end if
float2str_int = abs( float2str_int)
float2str_flo! = abs!( float2str_flo!)
'==//+�Ǳ���Ҫ�ģ�~~��Ȼ��������~
float2str_int = ( float2str_flo! - float2str_int) * 1000000.0 + 0.199999

float2str_rint$ = str$( float2str_int)

float2str_i = len( float2str_rint$) - 1
float2str_re$ = float2str_re$ + "." + right$( "000000", 5 - float2str_i)

while float2str_i and mid$( float2str_rint$, float2str_i, 1) = "0"

float2str_i = float2str_i - 1
wend

float2str_re$ = float2str_re$ + mid$( float2str_rint$, 0, float2str_i + 1)
float2str$ = float2str_re$
end function

'//��ʾ
function Cal_Show()

dim shared Cal_Show_num, Cal_Show_x, Cal_Show_y, Cal_Show_ppos, Cal_Show_len
dim shared cal_Show_str$, cal_Show_ZF

cal_Show_str$ = cal_Op_cur$

Cal_Show_ppos = instr( 0, ".", cal_Show_str$)
Cal_Show_len = len( cal_Show_str$)

showpic( cal_page_Catch, cal_pic_KB, 0, 0, 240, 67, 0, 0, 0)

if Cal_Show_ppos > 0 then
	Cal_Show_x = 230
else
	showpic(  cal_page_Catch, cal_pic_S, 214, 17, 16, 28, 100, 0, 1)
	Cal_Show_x = 214
end if
'cls
'print "����ѽ���ԣ�������������������������"
'print "x";Cal_Show_x
'print "cur";cal_Op_cur$
'print "str";cal_Show_str$
'print "pos";Cal_Show_ppos

'waitkey()

ShowFloat( cal_page_Catch, cal_pic_Num, Cal_Show_x, 17, cal_Show_str$)

if cal_data_m_State then
	showpic(  cal_page_Catch, cal_pic_S, 6, 17, 20, 18, 80, 0, 1)
end if

STRETCHBLTPAGEEX( 0, 0, 240, 67, 0, 0, - 1, cal_page_Catch)

end function

'//��Ȼ���Ҷ��� Ҳ�����Ҷ��룬��΢�ĸľͺ���
function ShowFloat( ShowFloat_p_hPage, ShowFloat_p_hImg, ShowFloat_p_x, ShowFloat_p_y, ShowFloat_p_Float$)
dim shared ShowFloat_at_x, ShowFloat_at_y, ShowFloat_pic_wid, ShowFloat_pic_heg, ShowFloat_cur
dim shared ShowFloat_hPage, ShowFloat_hImg, ShowFloat_i
dim shared ShowFloat_Float$, ShowFloat_Len

ShowFloat_Float$ = ShowFloat_p_Float$

ShowFloat_hPage = ShowFloat_p_hPage
ShowFloat_hImg = ShowFloat_p_hImg

ShowFloat_at_x = ShowFloat_p_x
ShowFloat_at_y = ShowFloat_p_y

ShowFloat_pic_wid = getpicwid( ShowFloat_hImg) / 12
ShowFloat_pic_heg = getpichgt( ShowFloat_hImg)

ShowFloat_Len = len( ShowFloat_Float$)

while ShowFloat_Len
ShowFloat_Len = ShowFloat_Len - 1
	ShowFloat_at_x = ShowFloat_at_x - ShowFloat_pic_wid
	ShowFloat_cur = asc( mid$( ShowFloat_Float$, ShowFloat_Len, 1))
	
	if ShowFloat_cur > 47 and ShowFloat_cur < 58 then
		ShowFloat_cur = ShowFloat_cur - 48
	else if ShowFloat_cur > 44 and ShowFloat_cur < 47  then
		ShowFloat_cur = ShowFloat_cur - 45 + 10
	else
		print "ShowFloat=�쳣�ַ�"
	end if
	
	showpic( ShowFloat_hPage, ShowFloat_hImg, ShowFloat_at_x, ShowFloat_at_y, ShowFloat_pic_wid, ShowFloat_pic_heg, ShowFloat_cur * ShowFloat_pic_wid, 0, 1)
wend


end function

asm
jmp Cal_QingWuShi:

Cal_Calculate:
;��������
;�������д���е��ң�Ӧ�������µ�
endasm


if cal_Op_state = 1 or cal_Op_state = 2 or cal_Op_state = 4 then
	cal_Operator = cal_CurOperator
end if

'==//����=�����
if cal_CurOperator = Cal_Code_Equ then
	cal_CurOperator = cal_Operator
	
	if cal_spc_equ = 1 then
	 	cal_spc_equ = 2
	else if cal_spc_equ = 0 then
		cal_spc_equ = 1
	end if

else
	cal_spc_equ = 0
end if
	
if cal_Op_state = 1 then
	cal_op_1! = str2float!( cal_Op_cur$)
	cal_Op_cur$ = "0"
	
	cal_Op_state = 2
	
else if cal_Op_state = 3 or cal_Op_state = 5 then
	if cal_spc_equ <> 2 then
	cal_op_2! = str2float!( cal_Op_cur$)
	end if
	
	vasm(" call Cal_Calculate_AnyType:")
	cal_Op_cur$ = float2str$( cal_op_re!)
	
	cal_op_1! = cal_op_re!
	
cal_Op_state = 4
end if


if cal_Op_state = 5 then
	cal_Operator = cal_CurOperator
cal_Op_state = 3
end if

asm
ret
Cal_Calculate_AnyType:
endasm

if cal_operator = Cal_Code_Add then
	cal_op_re! = cal_op_1! + cal_op_2!
else if cal_operator = Cal_Code_Sub then
	cal_op_re! = cal_op_1! - cal_op_2!
else if cal_operator = Cal_Code_Mul then
	cal_op_re! = cal_op_1! * cal_op_2!
else if cal_operator = Cal_Code_Div then
	cal_op_re! = cal_op_1! / cal_op_2!
end if

asm
ret
Cal_QingWuShi:

endasm















