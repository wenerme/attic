const ScreenPrint_Use_File_ID = 1
const ScrP_touch_id_Selected_LT = &h01
const ScrP_touch_id_Selected_RB = &h02

'//=========��ͼ�ຯ��v1.0==========
declare function ScreenPrint_ALL( ScrP_p_page, ScrP_p_BMP_FileName$)
declare function ScreenPrint_Rect( ScrP_p_PAGE, ScrP_p_x, ScrP_p_y, ScrP_p_Wid, ScrP_p_Hgt, ScrP_p_BMP_FileName$)
declare function ScreenPrint_Supper( ScrP_p_page)
'//ȫ����ͼ


function ScreenPrint_ALL( ScrP_p_page, ScrP_p_BMP_FileName$)
'//=========��ͼ�ຯ�� ֮ȫ����ͼ==========
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
Dim Shared ScrP_src_x, ScrP_src_y
Dim Shared ScrP_x, ScrP_y, ScrP_page
Dim Shared ScrP_wid, ScrP_hgt
Dim Shared ScrP_FileHandle, ScrP_FileName$, ScrP_FileOffset
Dim Shared Scrp_DataOffSet, Scrp_Save_PreLine
Dim Shared ScrP_BMP_FileName$

ScrP_page = ScrP_p_page
ScrP_BMP_FileName$ = ScrP_p_BMP_FileName$

ScrP_FileHandle = ScreenPrint_Use_File_ID
ScrP_wid = 240
ScrP_hgt = 320

asm
call Scrp_CommonInitialization
call [ Scrp_MainProcess_TYPE ]
endasm

end function

'//���ν�ͼ
function ScreenPrint_Rect( ScrP_p_PAGE, ScrP_p_x, ScrP_p_y, ScrP_p_Wid, ScrP_p_Hgt, ScrP_p_BMP_FileName$)
'//=========��ͼ�ຯ�� ֮�ֲ���ͼ==========
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
Dim Shared ScrP_src_x, ScrP_src_y
Dim Shared ScrP_x, ScrP_y, ScrP_page
Dim Shared ScrP_wid, ScrP_hgt
Dim Shared ScrP_FileHandle, ScrP_FileName$, ScrP_FileOffset
Dim Shared Scrp_DataOffSet, Scrp_Save_PreLine
Dim Shared ScrP_BMP_FileName$

ScrP_page = ScrP_p_PAGE

ScrP_FileHandle = ScreenPrint_Use_File_ID
ScrP_BMP_FileName$ = ScrP_p_BMP_FileName$

ScrP_src_x = ScrP_p_x
ScrP_src_y = ScrP_p_y
ScrP_Wid = ScrP_p_Wid
ScrP_hgt = ScrP_p_Hgt
asm
;'����������
call Scrp_CommonInitialization
call [ Scrp_MainProcess_TYPE ]
endasm

end function

'//������ͼ����
function ScreenPrint_Supper( ScrP_p_page)
'//=========��ͼ�ຯ�� ֮������ͼ==========
'���� Wener
'��̳Id a3160586 (club.eebbk.com   �����)
'QQ 514403150
Dim shared ScrP_src_x, ScrP_src_y
Dim shared ScrP_x, ScrP_y, ScrP_page
Dim shared ScrP_wid, ScrP_hgt
Dim shared ScrP_FileHandle, ScrP_FileName$, ScrP_FileOffset
Dim shared Scrp_DataOffSet, Scrp_Save_PreLine
Dim shared ScrP_BMP_FileName$

Dim shared ScrP_key_x, ScrP_key_y
Dim shared ScrP_key_up, ScrP_key_down, ScrP_key_left, ScrP_key_right
Dim shared ScrP_key_escape, ScrP_key_enter
Dim shared ScrP_touch_x, ScrP_touch_y	'�������X Y
Dim shared ScrP_touch_ID	'���������idֵ
Dim shared Scrp_Supper_UI

Dim shared Scrp_SuperState
'//������ ѡ������ selected
Dim shared Scrp_Super_Sel_Left, Scrp_Super_Sel_Right, Scrp_Super_Sel_Top, Scrp_Super_Sel_Bottom
Dim shared Scrp_Super_Sel_Wid, Scrp_Super_Sel_Hgt
'//��ŵ�ǰѡ�е��ָ��
Dim shared Scrp_Super_CurP_X, Scrp_Super_CurP_Y, Scrp_Super_CurSel
Dim shared Scrp_Super_Dis_X, Scrp_Super_Dis_Y

'//ҳ�����
Dim shared Scrp_Super_CatchPage, Scrp_Super_SrcPage, Scrp_Super_GrayPage, Scrp_Super_MenuPage
Dim shared Scrp_Supper_Waiting_IM , Scrp_Supper_Menu_IM, Scrp_Supper_Menu_PR_IM


'//��ʱ����
Dim shared Scrp_Super_Tick, Scrp_Super_DrawDelay
'/�˵�
Dim shared Scrp_Super_Menu_Delay, Scrp_Super_Menu_Alpha!, Scrp_Super_FadeOut_Delay
Dim shared Scrp_Super_Menu_Show_State

Dim shared Scrp_Super_Save_Type '0ΪBmp��1Ϊlib

Dim shared Scrp_Super_Temp_X, Scrp_Super_Temp_Y
Dim shared Scrp_Fe$

IF GetEnv!() = Env_SIM Then
	Scrp_Fe$ = ".rlb"
Else
	Scrp_Fe$ = ".lib"
End IF

Scrp_Super_SrcPage = createpage()

BITBLTPAGE( Scrp_Super_SrcPage, ScrP_p_page)

asm
call Scrp_Supper_Main:

Scrp_Supper_Main_END:
endasm
deletepage( Scrp_Super_CatchPage)
deletepage( Scrp_Super_SrcPage)
deletepage( Scrp_Super_GrayPage)
deletepage( Scrp_Super_MenuPage)

freeres( Scrp_Supper_Waiting_IM)
freeres( Scrp_Supper_Menu_IM)
freeres( Scrp_Supper_Menu_PR_IM)

end function

asm
jmp Scrp_Super_QingWuShi:
;//=================������ͼ�����ĺ�������=======================//
scrp_Supper_Main:
endasm
Scrp_Super_Sel_Left = 60
Scrp_Super_Sel_Right = 180
Scrp_Super_Sel_Top = 80
Scrp_Super_Sel_Bottom = 240
setlcd( 240, 320)
Scrp_Super_CatchPage = createpage()

Scrp_Super_GrayPage = createpage()
Scrp_Super_MenuPage = createpage()
setpen( Scrp_Super_CatchPage, 1, 0, &hffffff)


Scrp_Supper_Waiting_IM = loadres( "ScrP_UI" + Scrp_Fe$, 1)
Scrp_Supper_Menu_IM = loadres( "ScrP_UI" + Scrp_Fe$, 2)
Scrp_Supper_Menu_PR_IM = loadres( "ScrP_UI" + Scrp_Fe$, 3)

'��ʾ�˵����˵��Ļ���ҳ
showpic( Scrp_Super_MenuPage, Scrp_Supper_Menu_IM, 116, 0, 124, 24, 0, 0, 1 )

'��ʼѡ��Ŀ��Ƶ�
Scrp_Super_CurSel = ScrP_touch_id_Selected_LT

BITBLTPAGE( Scrp_Super_GrayPage, Scrp_Super_SrcPage)

asm
;'�ҶȻ�ҳ��
call Scrp_Super_PageGray_Main_Proc:

;'��ʼ���Ƶ�
ld int [ vint_Scrp_Super_CurP_X ], vint_Scrp_Super_Sel_Left
ld int [ vint_Scrp_Super_CurP_Y ], vint_Scrp_Super_Sel_Top

;'��ʼ��ͼ
call Scrp_Super_DrawRect:
endasm

'�˵���ʼ
Scrp_Super_Menu_Alpha! = 0.0
Scrp_Super_FadeOut_Delay = gettick()

showpic( Scrp_Super_MenuPage, Scrp_Supper_Menu_PR_IM, 215, 0, 25, 12, 99, Scrp_Super_Save_Type * 12, 1)

'//====================��ѭ��===================//
Scrp_SuperState = 1
while Scrp_SuperState = 1

flippage( Scrp_Super_CatchPage)
ScrP_User_Inkey = inkey()
vasm(" call Scrp_Super_GetInput:")

Scrp_Super_Tick = gettick()

'//==ѡ��򻺶�==
if ( Scrp_Super_Tick - Scrp_Super_DrawDelay ) > 100 and ( Scrp_Super_Dis_X or Scrp_Super_Dis_Y ) then

'Scrp_Super_Temp_X, Scrp_Super_Temp_Y һ�ε��ƶ���
Scrp_Super_Temp_X = Scrp_Super_Dis_X * 0.5
Scrp_Super_Temp_Y = Scrp_Super_Dis_Y * 0.5

asm

ld int r1, [ vint_Scrp_Super_CurP_X ]
ld int r2, [ vint_Scrp_Super_CurP_Y ]

cal int add [ r1 ], [ vint_Scrp_Super_Temp_X ]
cal int add [ r2 ], [ vint_Scrp_Super_Temp_Y ]

call Scrp_Super_DrawRect:
endasm

Scrp_Super_Dis_X = Scrp_Super_Dis_X - Scrp_Super_Temp_X
Scrp_Super_Dis_Y = Scrp_Super_Dis_Y - Scrp_Super_Temp_Y

Scrp_Super_DrawDelay = gettick()
end if

'//==�˵��ĵ��뵭��==
if Scrp_Super_Menu_Show_State then
if ( Scrp_Super_Tick - Scrp_Super_FadeOut_Delay ) > 2500 then
	
	'/���￪ʼ��������
	if ( Scrp_Super_Tick - Scrp_Super_Menu_Delay) > 200 then
	asm
	;'��ʼ��ͼ
	call Scrp_Super_DrawRect:
	
	call Scrp_Super_AphlaMix_Process:

	;'���ǲ��ִ��¿������˵��Ļ���ҳ,λ�þ���Դ�˵�������
	ld int [ Scrp_Super_Show_MenuPage_Para_dest ], [ vint_Scrp_Super_MenuPage ]
	ld int [ Scrp_Super_Show_MenuPage_Para_src ], [ vint_Scrp_Super_CatchPage ]

	ld int [ Scrp_Super_Show_MenuPage_Para_src_y ], 0
	ld int [ Scrp_Super_Show_MenuPage_Para_dest_y ], 24
	
	ld int r3, Scrp_Super_Show_MenuPage_Para_Src
	OUT 80,0
	endasm
	
	Scrp_Super_Menu_Alpha! = Scrp_Super_Menu_Alpha! + 0.1
	Scrp_Super_Menu_Delay = gettick()
	
	else if Scrp_Super_Menu_Alpha! > 0.8 then
	
	
	'����
	Scrp_Super_Menu_Alpha! = 0
	Scrp_Super_Menu_Show_State = 0
	
	'��ʾ��������
	else
	
	asm
	;'������ÿ�ζ���Alpha��ϼ��㣬���Ծ���ʾ�����
	ld int [ Scrp_Super_Show_MenuPage_Para_src ], [ vint_Scrp_Super_MenuPage ]
	ld int [ Scrp_Super_Show_MenuPage_Para_Dest ], [ vint_Scrp_Super_CatchPage ]

	ld int [ Scrp_Super_Show_MenuPage_Para_dest_y ], 0
	ld int [ Scrp_Super_Show_MenuPage_Para_src_y ], 24

		ld int r3, Scrp_Super_Show_MenuPage_Para_Src
		OUT 80,0

	endasm
	
	end if




else 

asm
;'��ʾ�˵�
;'�����ǰ����ʾ�����º��水�����ٴ�ˢ��ҳ���ʱ���û�������������һ���о����ǿ��Ե�
ld int [ Scrp_Super_Show_MenuPage_Para_Dest ], [ vint_Scrp_Super_CatchPage ]
ld int [ Scrp_Super_Show_MenuPage_Para_Src ], [ vint_Scrp_Super_MenuPage ]

ld int [ Scrp_Super_Show_MenuPage_Para_src_y ], 0
ld int [ Scrp_Super_Show_MenuPage_Para_dest_y ], 0
	ld int r3, Scrp_Super_Show_MenuPage_Para_Src
	OUT 80,0

endasm
end if

end if




'//����˵����
if ScrP_key_escape then

	if Scrp_Super_Menu_Show_State then
	else
		Scrp_Super_Menu_Show_State = 1
		Scrp_Super_FadeOut_Delay = gettick()
		vasm(" call Scrp_Super_DrawRect:") 'ˢ��ҳ��
	end if
	
'//������ͨ���
else if ScrP_touch_id > 0 then





'//�������ļ��̲���
else 
'==//�˳�
if ScrP_key_escape then
	Scrp_SuperState = 0
'==//ȷ��
else if ScrP_key_Enter then
	vasm(" call Scrp_Super_Save")
'==//ʣ�µ�ֻ�з������
else if ScrP_key_left or ScrP_key_Right or ScrP_key_up or ScrP_key_down then
	
	Scrp_Super_Temp_X = - ScrP_key_left + ScrP_key_Right
	Scrp_Super_Temp_Y = - ScrP_key_up + ScrP_key_down 
	
	if ( Scrp_Super_Sel_Left + Scrp_Super_Temp_X ) >= 0 and ( Scrp_Super_Sel_Right + Scrp_Super_Temp_X ) < 240 and ( Scrp_Super_Sel_Top + Scrp_Super_Temp_Y ) >= 0 and ( Scrp_Super_Sel_bottom + Scrp_Super_Temp_Y ) < 320  then
	
		Scrp_Super_Sel_Left = Scrp_Super_Sel_Left + Scrp_Super_Temp_X
		Scrp_Super_Sel_Right = Scrp_Super_Sel_Right + Scrp_Super_Temp_X
		Scrp_Super_Sel_Top = Scrp_Super_Sel_Top + Scrp_Super_Temp_Y
		Scrp_Super_Sel_Bottom = Scrp_Super_Sel_Bottom + Scrp_Super_Temp_Y
	
	

	asm
	call Scrp_Super_DrawRect:
	endasm
	
	end if
	
end if

end if



wend

asm
ret

;'//======================��ȡ������Ϣ
Scrp_Super_GetInput:
endasm
'==/////===========����
if ScrP_User_Inkey < 0 then
	ScrP_touch_x = getpenposx( ScrP_User_Inkey)
	ScrP_touch_y = getpenposy( ScrP_User_Inkey)
	ScrP_touch_id = -1
	VASM(" call Scrp_Super_calTouchId") '���㴥��
	
else
	ScrP_touch_x = -1
	ScrP_touch_y = -1
	ScrP_touch_id = -1
end if
'==/////=========== �����
VASM("LD INT r3,38") '//==UP
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_key_up],r3")

VASM("LD INT r3,40") '//==DOWN
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_Key_Down],r3")

VASM("LD INT r3,37") '//==left
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_Key_Left],r3")

VASM("LD INT r3,39") '//==right
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_Key_Right],r3")
'//==============������
VASM("LD INT r3,13") '//==ENTER
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_Key_Enter],r3")

VASM("LD INT r3,27") '//==ESCAPE
VASM("OUT 34,0")
VASM("LD INT [VINT_ScrP_Key_Escape],r3")
asm
ret

;'STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)
;��ʾ�˵�ҳ�Ĳ���
data Scrp_Super_Show_MenuPage_Para_Src dword 0
data Scrp_Super_Show_MenuPage_Para_Dest dword 0
data Scrp_Super_Show_MenuPage_Para_src_Y dword 0, 116, 24, 124
data Scrp_Super_Show_MenuPage_Para_dest_Y dword 0, 116
;�ܹ���yֵ�����޸ģ���ʾ��һ���Ļ���

;����һЩ�˿ڵĲ����б�
Scrp_Super_Paramater_8:
.block 4 0
Scrp_Super_Paramater_7:
.block 4 0
Scrp_Super_Paramater_6:
.block 4 0
Scrp_Super_Paramater_5:
.block 4 0
Scrp_Super_Paramater_4:
.block 4 0
Scrp_Super_Paramater_3:
.block 4 0
Scrp_Super_Paramater_2:
.block 4 0
Scrp_Super_Paramater_1:
.block 4 0
Scrp_Super_Paramater_Catch:

;��ɫ
Scrp_Super_ColorBlue:
.block 1 0
Scrp_Super_ColorGreen:
.block 1 0
Scrp_Super_ColorRed:
.block 2 0

;//============ҳ���ҹ���---��ɫ����==============//
;��ɫ����
Scrp_Super_HalfGray:
;������� r0
;������� r0

ld int [ Scrp_Super_ColorBlue ], r0

cal byte div [ Scrp_Super_ColorBlue ], 2
cal byte div [ Scrp_Super_ColorGreen ], 2
cal byte div [ Scrp_Super_ColorRed ], 2

ld int r0, [ Scrp_Super_ColorBlue ]

ret

;//========����ҳ��==========//
;���������ĺ��ģ����Դ󲿷ֻ�࣬�����ٶȲ��Ǻܿ��
;'//���λ���  ��Ϊ���λ��ƺ��������⣬���Բ��õ��������
Scrp_Super_DrawRect:

;ҳ�����
;���ûҶȵ��������ҳ��
;BITBLTPAGE(DEST,SRC)
;Scrp_Super_CatchPage, Scrp_Super_SrcPage, Scrp_Super_GrayPage

ld int r2, [ vint_Scrp_Super_CatchPage ]
ld int r3, [ vint_Scrp_Super_GrayPage ]

OUT 22,0
;��ʾԭҳ��
;'STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)

ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_Sel_Left ]
ld int [ Scrp_Super_Paramater_2 ], [ vint_Scrp_Super_Sel_Top ]

ld int r1, [ vint_Scrp_Super_Sel_Left ]
ld int r2, [ vint_Scrp_Super_Sel_Right ]
cal int sub r2, r1

ld int [ Scrp_Super_Paramater_3 ], r2	'wid

ld int r1, [ vint_Scrp_Super_Sel_Top ]
ld int r2, [ vint_Scrp_Super_Sel_Bottom ]
cal int sub r2, r1

ld int [ Scrp_Super_Paramater_4 ], r2	'hgt
ld int [ Scrp_Super_Paramater_5 ], [ vint_Scrp_Super_Sel_Left ]
ld int [ Scrp_Super_Paramater_6 ], [ vint_Scrp_Super_Sel_Top ] 
ld int [ Scrp_Super_Paramater_7 ], [ vint_Scrp_Super_CatchPage ]
ld int [ Scrp_Super_Paramater_8 ], [ vint_Scrp_Super_SrcPage ]

ld int r3, Scrp_Super_Paramater_8
OUT 80,0

;'==//���ƾ��ο�
ld int r1, [ vint_Scrp_Super_CatchPage ]

;MoveTo����
ld int r2, [ vint_Scrp_Super_Sel_Left ]
ld int r3, [ vint_Scrp_Super_Sel_Top ]
out 66, 0

;LineTo����
ld int r2, [ vint_Scrp_Super_Sel_Right ]
out 67, 0

;LineTo����
ld int r3, [ vint_Scrp_Super_Sel_Bottom ]
out 67, 0

;LineTo����
ld int r2, [ vint_Scrp_Super_Sel_Left ]
out 67, 0
;LineTo����
ld int r3, [ vint_Scrp_Super_Sel_Top ]
out 67, 0


;'��������в������������ҳ����
ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_CatchPage ]
;'==//���ƿ��Ƶ�
ld int [ Scrp_Super_Paramater_4 ], 10	'wid
ld int [ Scrp_Super_Paramater_5 ], 10	'hgt
ld int [ Scrp_Super_Paramater_6 ], 16777215	'color 0xffffff
;'=/���ϵ�
ld int [ Scrp_Super_Paramater_2 ], [ vint_Scrp_Super_Sel_Left ]
ld int [ Scrp_Super_Paramater_3 ], [ vint_Scrp_Super_Sel_Top ]

cal int add [ Scrp_Super_Paramater_2 ], - 5
cal int add [ Scrp_Super_Paramater_3 ], - 5

ld int r3, Scrp_Super_Paramater_6
OUT 23,0
;'=/���µ�
ld int [ Scrp_Super_Paramater_2 ], [ vint_Scrp_Super_Sel_Right ]
ld int [ Scrp_Super_Paramater_3 ], [ vint_Scrp_Super_Sel_Bottom ]

cal int add [ Scrp_Super_Paramater_2 ], - 5
cal int add [ Scrp_Super_Paramater_3 ],  - 5

ld int r3, Scrp_Super_Paramater_6
OUT 23,0

;'==//��ǰѡ�п��Ƶ�
ld int r1, [ vint_Scrp_Super_CurP_X ]
ld int r2, [ vint_Scrp_Super_CurP_Y ]

ld int [ Scrp_Super_Paramater_2 ], [ r1 ]	'x
ld int [ Scrp_Super_Paramater_3 ], [ r2 ]	'y

cal int add [ Scrp_Super_Paramater_2 ], - 3
cal int add [ Scrp_Super_Paramater_3 ],  - 3

ld int [ Scrp_Super_Paramater_4 ], 6	'wid
ld int [ Scrp_Super_Paramater_5 ], 6	'hgt
ld int [ Scrp_Super_Paramater_6 ], 16711680	'color 0xff ����Ӧ���Ǻ�ɫ����bb������ɫ

OUT 23,0

ret

;'//=================���㴥����Id======================//
Scrp_Super_calTouchId:
endasm

'//===============================�˵���ʾ��ʱ���ʱ�򣬼��ѡ��Ĳ˵���
if Scrp_Super_Menu_Show_State and ScrP_touch_x > 118 and ScrP_touch_Y < 22 then

'ѡ���˲˵�����


Scrp_Super_Temp_X = ScrP_touch_x - 118
Scrp_Super_FadeOut_Delay = gettick()

'�˵�ѡ��������ﴦ���ˣ����ٷ������洦��
	if Scrp_Super_Temp_X < 10 then
	Scrp_SuperState = 0
	
	else if Scrp_Super_Temp_X < 25 then
	
	Scrp_Super_Sel_Left = 0
	Scrp_Super_Sel_Right = 239
	Scrp_Super_Sel_Top = 0 
	Scrp_Super_Sel_Bottom = 319
	
	Scrp_Super_Dis_X = 0
	Scrp_Super_Dis_T = 0
	
	else if Scrp_Super_Temp_X < 62 then
	
	vasm(" call Scrp_Super_Save")
	
	'���
	else if Scrp_Super_Temp_X < 99 then
	
	fillpage( -1, 0, 0, 240, 320, 0)
	Scrp_Super_Sel_Wid = Scrp_Super_Sel_Right - Scrp_Super_Sel_Left + 1
	Scrp_Super_Sel_Hgt = Scrp_Super_Sel_bottom - Scrp_Super_Sel_top + 1
	
	STRETCHBLTPAGEEX( ( 240 - Scrp_Super_Sel_Wid ) / 2, ( 320 - Scrp_Super_Sel_Hgt ) / 2, Scrp_Super_Sel_Wid, Scrp_Super_Sel_Hgt, Scrp_Super_Sel_left, Scrp_Super_Sel_top, - 1, Scrp_Super_SrcPage)
	
	waitkey()
	
	'ѡ�񱣴�ĸ�ʽ
	else 
	
	showpic( Scrp_Super_MenuPage, Scrp_Supper_Menu_IM, 215, Scrp_Super_Save_Type * 12, 25, 12, 99, Scrp_Super_Save_Type * 12, 1)
	
	if ScrP_touch_Y < 12 then
	Scrp_Super_Save_Type = 0
	else 
	Scrp_Super_Save_Type = 1
	end if
	
	showpic( Scrp_Super_MenuPage, Scrp_Supper_Menu_PR_IM, 215, Scrp_Super_Save_Type * 12, 25, 12, 99, Scrp_Super_Save_Type * 12, 1)

	end if

'//===============================��ͨ���
else

'���㴥����Χ  �Ƿ�ѡ�п��Ƶ�
if ScrP_touch_x < Scrp_Super_Sel_Left + 5 and ScrP_touch_x > Scrp_Super_Sel_Left - 5 and ScrP_touch_y < Scrp_Super_Sel_Top + 5 and ScrP_touch_y > Scrp_Super_Sel_Top - 5 then

ScrP_touch_id = ScrP_touch_id_Selected_LT
Scrp_Super_CurSel = ScrP_touch_id_Selected_LT
asm

ld int [ vint_Scrp_Super_CurP_X ], vint_Scrp_Super_Sel_Left
ld int [ vint_Scrp_Super_CurP_Y ], vint_Scrp_Super_Sel_Top

call Scrp_Super_DrawRect:
endasm
else if ScrP_touch_x < Scrp_Super_Sel_right + 5 and ScrP_touch_x > Scrp_Super_Sel_right - 5 and ScrP_touch_y < Scrp_Super_Sel_bottom + 5 and ScrP_touch_y > Scrp_Super_Sel_bottom - 5 then

ScrP_touch_id = ScrP_touch_id_Selected_RB
Scrp_Super_CurSel = ScrP_touch_id_Selected_RB
asm

ld int [ vint_Scrp_Super_CurP_X ], vint_Scrp_Super_Sel_Right
ld int [ vint_Scrp_Super_CurP_Y ], vint_Scrp_Super_Sel_Bottom

call Scrp_Super_DrawRect:
endasm


else

Scrp_Super_DrawDelay = gettick()

'//����Ҫ���߽� �����㲻�ܱ任
if Scrp_Super_CurSel = ScrP_touch_id_Selected_LT then
	
	if ScrP_touch_x < Scrp_Super_Sel_Right and ScrP_touch_y < Scrp_Super_Sel_Bottom then
	
		Scrp_Super_Dis_X = ScrP_touch_x - Scrp_Super_Sel_Left
		Scrp_Super_Dis_Y = ScrP_touch_y - Scrp_Super_Sel_Top
	
	end if
else

	if ScrP_touch_x > Scrp_Super_Sel_Left and ScrP_touch_y > Scrp_Super_Sel_Top then
	
		Scrp_Super_Dis_X = ScrP_touch_x - Scrp_Super_Sel_Right
		Scrp_Super_Dis_Y = ScrP_touch_y - Scrp_Super_Sel_Bottom
	
	end if

end if

'����ǽ�����ͨ�����Ļ��
end if

'����ǽ���esc�жϵ�
end if

asm
ret

;//==========����===========//
Scrp_Super_Save:
endasm

ScrP_page = Scrp_Super_SrcPage

ScrP_src_x = Scrp_Super_Sel_Left
ScrP_src_y = Scrp_Super_Sel_top
ScrP_Wid = Scrp_Super_Sel_Right - Scrp_Super_Sel_Left + 1
ScrP_hgt = Scrp_Super_Sel_bottom - Scrp_Super_Sel_top + 1

ScrP_FileHandle = ScreenPrint_Use_File_ID

'��Ϊlib
if Scrp_Super_Save_Type then

ScrP_BMP_FileName$ = ""

'��ΪBmp
else

ScrP_BMP_FileName$ = "SP_Wen" + gettick()
end if

showpic( -1, Scrp_Supper_Menu_PR_IM, 116, 0, 100, 24, 0, 24, 1)

asm
;'����������
call Scrp_CommonInitialization
call [ Scrp_MainProcess_TYPE ]
endasm

showpic( -1, Scrp_Supper_Menu_PR_IM, 116, 0, 100, 24, 0, 0, 1)

waitkey()

asm
ret

;//==========ҳ��ҶȻ�����Ҫ����===========//
;�ٶȽϿ죬��С����һ�붼�ò���
Scrp_Super_PageGray_Main_Proc:

ld int [ vint_Scrp_Super_Temp_Y ], 0
ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_GrayPage ]

;'Scrp_Super_Temp_Y = 0
;'while Scrp_Super_Temp_Y < 320

Scrp_Super_GrayPage_y_Bend:
cmp int [ vint_Scrp_Super_Temp_Y ], 320
jpc AE Scrp_Super_GrayPage_y_Wend:
	
	ld int [ vint_Scrp_Super_Temp_x ], 0
	
;'	Scrp_Super_Temp_X = 0
;'	while Scrp_Super_Temp_X < 240

	Scrp_Super_GrayPage_x_Bend:
	cmp int [ vint_Scrp_Super_Temp_X ], 240
	jpc AE Scrp_Super_GrayPage_x_Wend:
		
		
		;' readpixel
		;'ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_CatchPage ]
		ld int [ Scrp_Super_Paramater_2 ], [ vint_Scrp_Super_Temp_X ]
		;'ld int [ Scrp_Super_Paramater_3 ], [ vint_Scrp_Super_Temp_Y ]
		
		ld int r3, Scrp_Super_Paramater_3
		OUT 25,0
		
		ld int r0, r3
		
		;'������ɫ
		call Scrp_Super_HalfGray
		
		;' pixel
		ld int [ Scrp_Super_Paramater_4 ], r0
		ld int r3, Scrp_Super_Paramater_4
		OUT 24,0
		
		
		cal int add [ vint_Scrp_Super_Temp_X ], 1
		
	;'Scrp_Super_Temp_X = Scrp_Super_Temp_X + 1
	;'wend
	jmp Scrp_Super_GrayPage_x_Bend:
	Scrp_Super_GrayPage_X_Wend:

cal int add [ vint_Scrp_Super_Temp_Y ], 1
ld int [ Scrp_Super_Paramater_3 ], [ vint_Scrp_Super_Temp_Y ]

;��ʾ�ȴ�ͼƬ
call Scrp_Supper_Show_Waiting_Img:
;'Scrp_Super_Temp_Y = Scrp_Super_Temp_Y + 1
;'wend

jmp Scrp_Super_GrayPage_y_Bend:
Scrp_Super_GrayPage_Y_Wend:

ret

;//===========��ʾ�ȴ���ͼƬ===========//
;ÿ����20����ʾһ�� ������û����ô�˷�ʱ��
data Scrp_Supper_Show_Waiting_Img_Times dword 0

data Scrp_Supper_Show_Waiting_Img_p_9 dword 0
data Scrp_Supper_Show_Waiting_Img_p_8 dword 0
data Scrp_Supper_Show_Waiting_Img_p_7 dword 0
data Scrp_Supper_Show_Waiting_Img_p_6 dword 40
data Scrp_Supper_Show_Waiting_Img_p_5 dword 40
data Scrp_Supper_Show_Waiting_Img_p_4 dword 280
data Scrp_Supper_Show_Waiting_Img_p_3 dword 0
data Scrp_Supper_Show_Waiting_Img_p_2 dword 0
data Scrp_Supper_Show_Waiting_Img_p_1 dword - 1


;WaitProc
Scrp_Supper_Show_Waiting_Img:

cal int mod [ Scrp_Supper_Show_Waiting_Img_Times ], 20
cmp int [ Scrp_Supper_Show_Waiting_Img_Times ], 0
jpc NZ Scrp_Supper_Show_Waiting_Img_End


cal int mod [ Scrp_Supper_Show_Waiting_Img_p_7 ], 200


ld int [ Scrp_Supper_Show_Waiting_Img_p_2 ], [ vint_Scrp_Supper_Waiting_IM ]
ld int r3, Scrp_Supper_Show_Waiting_Img_p_9
out 20, 0

cal int add [ Scrp_Supper_Show_Waiting_Img_p_7 ], 40

Scrp_Supper_Show_Waiting_Img_End:

cal int add [ Scrp_Supper_Show_Waiting_Img_Times ], 1

ret


;'��Ҫ������źϳ���ɫ�ĵĿռ�
Scrp_Super_Temp_ColorBlue:
.block 1 0
Scrp_Super_Temp_ColorGreen:
.block 1 0
Scrp_Super_Temp_ColorRed:
.block 2 0

;alpha���
;//===============Alpha��ϵ�������==================//
Scrp_Super_AphlaMix:
;���� ͸���� r0 ���ɫ r1, ԭɫ r2 
;ע�� r3 �ķ�Χ�� 0 - 1 �ĸ�����
;���� r1
; C1 * Al + c2 * ( 1 - al ) = C1 * al + c2 - c2 * al


ld int [ Scrp_Super_ColorBlue ], r1
ld int [ Scrp_Super_temp_ColorBlue ], r2



;B
;'ÿ�ζ�Ҫ��0
ld int r3, 0

ld byte r3, [ Scrp_Super_ColorBlue ]
in r1, 1

ld byte r3, [ Scrp_Super_temp_ColorBlue ]
in r2, 1

;call Scrp_Super_AphlaMix_Sub_One:
cal float mul r1, r0
cal float add r1, r2
cal float mul r2, r0
cal float sub r1, r2
ld int r3, r1
in r1, 0

ld byte [ Scrp_Super_ColorBlue ], r1

;G
ld int r3, 0

ld byte r3, [ Scrp_Super_ColorGreen ]
in r1, 1

ld byte r3, [ Scrp_Super_temp_ColorGreen ]
in r2, 1

;call Scrp_Super_AphlaMix_Sub_One:

cal float mul r1, r0
cal float add r1, r2
cal float mul r2, r0
cal float sub r1, r2
ld int r3, r1
in r1, 0

ld byte [ Scrp_Super_ColorGreen ], r1

;R
ld int r3, 0

ld byte r3, [ Scrp_Super_ColorRed ]
in r1, 1

ld byte r3, [ Scrp_Super_temp_ColorRed ]
in r2, 1

;call Scrp_Super_AphlaMix_Sub_One:
cal float mul r1, r0
cal float add r1, r2
cal float mul r2, r0
cal float sub r1, r2
ld int r3, r1
in r1, 0

ld byte [ Scrp_Super_ColorRed ], r1

;���ؽ��
ld int r1, [ Scrp_Super_ColorBlue ]

ret
;//===============Alpha���-ѭ��ȫ����==================//
;��һ����Ҫ�󾡿��ܵĿ�  �����ںܶ�ط����������£������ʱ����ֱ���õĲ����������
;���ܿ������е㲻̫���ף�������Ҳû�취��
;Ҫ����һ�����ˣ��ǻ�Ӱ��ʹ�õ�

Scrp_Super_AphlaMix_Process:
;��ʼ

;'Scrp_Super_Temp_Y = 0
ld int [ Scrp_Super_Paramater_3 ], 0

Scrp_Super_AphlaMix_Process_Y_Bend:
;'while Scrp_Super_Temp_Y < 24	
cmp int [ Scrp_Super_Paramater_3 ], 24
jpc AE Scrp_Super_AphlaMix_Process_Y_Wend
	
	;'Scrp_Super_Temp_X = 115
	ld int [ Scrp_Super_Paramater_2 ], 115
	Scrp_Super_AphlaMix_Process_X_Bend:
	;'while Scrp_Super_Temp_X < 240
	
	cmp int [ Scrp_Super_Paramater_2 ], 240
	jpc AE Scrp_Super_AphlaMix_Process_X_Wend
	
	;'cm = readpixel( m, x, Scrp_Super_Temp_Y )
	;'cn = readpixel( n, x, Scrp_Super_Temp_Y )
	
	ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_MenuPage ]
	ld int r3, Scrp_Super_Paramater_3
	OUT 25,0
	
	ld int r2, r3
	
	ld int [ Scrp_Super_Paramater_1 ], [ vint_Scrp_Super_CatchPage ]
	ld int r3, Scrp_Super_Paramater_3
	OUT 25,0
	
	ld int r1, r3
		
	ld int r0, [ vflo_Scrp_Super_Menu_Alpha]
	call Scrp_Super_AphlaMix:
	
	;�����ɫ
	ld int [ Scrp_Super_Paramater_4 ], r1
	'pixel( n, x, Scrp_Super_Temp_Y, cn )
	ld int r3, Scrp_Super_Paramater_4
	OUT 24,0
	
	
	cal int add [ Scrp_Super_Paramater_2 ], 1
	'wend
	jmp Scrp_Super_AphlaMix_Process_X_Bend
	Scrp_Super_AphlaMix_Process_X_Wend:
		

;'Scrp_Super_Temp_Y = Scrp_Super_Temp_Y + 1
;'wend

cal int add [ Scrp_Super_Paramater_3 ], 1
	
'wend
jmp Scrp_Super_AphlaMix_Process_Y_Bend
Scrp_Super_AphlaMix_Process_Y_Wend:

ret
Scrp_Super_QingWuShi:
endasm

asm
Jmp Scrp_QingWuShi:
;���ݿ�
Scrp_Catch:
.block 1 0
Scrp_Catch_SavePostion:
.block 4096 0

;��ɫ
Scrp_ColorTranslate_Catch_Blue:
.block 1 0
Scrp_ColorTranslate_Catch_Green:
.block 1 0
Scrp_ColorTranslate_Catch_Red:
.block 2 0

;16λɫ�Ļ���
Scrp_ColorTranslate_Catch_16Bit_1:
.block 1 0
Scrp_ColorTranslate_Catch_16Bit_2:
.block 3 0

;����һЩ�˿ڵĲ����б�
Scrp_Paramater_4:
.block 4 0
Scrp_Paramater_3:
.block 4 0
Scrp_Paramater_2:
.block 4 0
Scrp_Paramater_1:
.block 4 0
Scrp_Paramater_Catch:

;��ʼ���Ļ���
Scrp_Init_Bit1:
.block 2 0
Scrp_Init_Bit2:
.block 4 0

data Scrp_i dword 0
data Scrp_j dword 0
data Scrp_k dword 0
data Scrp_Color_Tranform_TYPE dword 0
data Scrp_SaveAs_TYPE dword 0
data Scrp_MainProcess_TYPE dword 0
;//=============��ɫת������=============//
;�ӹ��̣���BGR����ɫ��ʽ��RGB����ת��
;��������������Ƕ���ģ�Ӧ�ö������õ�~
Scrp_ColorTranslate:
;������ r0 
;���أ� r0




ld int [ Scrp_ColorTranslate_Catch_Blue ], r0
ld byte r0, [ Scrp_ColorTranslate_Catch_Blue ]

ld byte [ Scrp_ColorTranslate_Catch_Blue ], [ Scrp_ColorTranslate_Catch_Red ]
ld byte [ Scrp_ColorTranslate_Catch_Red ], r0

ld int r0, [ Scrp_ColorTranslate_Catch_Blue ]
ret
;
;//==========�ӹ��̣���R8 G8 B8ת����R5 G6 B5==========//
;'������ƣ���ʼΪ-1
data Scrp_ColorTranslate_LastColor_Catch dword %ffffffff%

Scrp_ColorCover_16Bit:
;����: r0
;����: r0 ����ֵ��8λ����ɫ

;'if r0 = LastColor_Catch ����
;\\
cmp int r0, [ Scrp_ColorTranslate_LastColor_Catch ]
jpc z Scrp_ColorTranslate_ColorEqual:

ld int [ Scrp_ColorTranslate_LastColor_Catch ], r0
;'������ε���ɫ��ͬ���򲻴���

;\\
ld int [ Scrp_ColorTranslate_Catch_Blue ], r0

ld int r1, 0
ld int r2, 0
ld int r3, 0
;��ɫ ȡɫ

call [ Scrp_Color_Tranform_TYPE ]


ld int r0, r1
cal int add r0, r2
cal int add r0, r3



;����00
ld int [ Scrp_ColorTranslate_Catch_16Bit_1 ], r0



;������߼�����ȷ ��ɫƫ��û��ô�ѿ�
; if bit12 = 0 then
;	bit12 = 2113
; else
;	if bite1 = 0 then
;		bit2 + 1
;		
;	else
;		bit2 + 8
;	end if
; end if


;12����word��Ҳ����1 2λ��1����1λ��2����2λ
; if bit12 = 0 then
cmp int [ Scrp_ColorTranslate_Catch_16Bit_1 ], 0
JPC NZ Scrp_ColorCover_Else_12:

ld int [ Scrp_ColorTranslate_Catch_16Bit_1 ], 2113

jmp Scrp_ColorCover_EndIf_12:
; else
Scrp_ColorCover_Else_12:

	;��һλ
	; if bite1 = 0 then
	cmp byte [ Scrp_ColorTranslate_Catch_16Bit_1 ], 0
	JPC NZ Scrp_ColorCover_Else_1:
	
	ld byte [ Scrp_ColorTranslate_Catch_16Bit_1 ], 1
	
	jmp Scrp_ColorCover_EndIf_12:
	; else if bite2 = 0 then
	Scrp_ColorCover_Else_1:

	cmp byte [ Scrp_ColorTranslate_Catch_16Bit_2 ], 0
	JPC NZ Scrp_ColorCover_EndIf_12:
	
	ld byte [ Scrp_ColorTranslate_Catch_16Bit_2 ], 8
	
Scrp_ColorCover_EndIf_12:



;'��ͬ����������
Scrp_ColorTranslate_ColorEqual:

ld int r0, [ Scrp_ColorTranslate_Catch_16Bit_1 ]

ret

;//=============��ɫת������====Lib �� BMP=================//
Scrp_Color_Tranform_LIB:

ld byte r1, [ Scrp_ColorTranslate_Catch_Red ]	;[ Scrp_ColorTranslate_Catch_Blue ]
ld byte r2, [ Scrp_ColorTranslate_Catch_Green ]
ld byte r3, [ Scrp_ColorTranslate_Catch_Blue ]	;[ Scrp_ColorTranslate_Catch_Red ]

cal int Div r1, 8
cal int Div r2, 4	;G6
cal int Div r3, 8

cal int mul r2, 32
cal int mul r3, 2048

ret

Scrp_Color_Tranform_BMP:

ld byte r1, [ Scrp_ColorTranslate_Catch_Red ]
ld byte r2, [ Scrp_ColorTranslate_Catch_Green ]
ld byte r3, [ Scrp_ColorTranslate_Catch_Blue ]


cal int Div r1, 8
cal int Div r2, 8
cal int Div r3, 8

cal int mul r2, 32
cal int mul r3, 1024

ret

;//=============���еĳ�ʼ��=====================//
Scrp_CommonInitialization:

;��ʼ������ ����ȷ��ֻ����һ��
ld int [ Scrp_Paramater_1 ], [ vint_ScrP_page ]

;��������ƫ��
ld int [ vint_Scrp_DataOffSet ], Scrp_Catch:

;��������б���һ��
ld int r0, [ vint_ScrP_wid ]
cal int mul r0, 2

ld int [ vint_Scrp_Save_PreLine ], 4095
cal int div [ vint_Scrp_Save_PreLine ], r0

endasm
'����Ϊ���ļ���ʽ
if ScrP_BMP_FileName$ = "" then

ScrP_FileName$ = "ScreenPrint.lib"
asm
ld int [ Scrp_SaveAs_TYPE ], Scrp_SaveAs_lib
ld int [ Scrp_Color_Tranform_TYPE ], Scrp_Color_Tranform_lib
ld int [ Scrp_MainProcess_TYPE ], Scrp_MainProcess_lib
endasm

else
ScrP_FileName$ = ScrP_BMP_FileName$ + ".bmp"
asm
ld int [ Scrp_SaveAs_TYPE ], Scrp_SaveAs_bmp
ld int [ Scrp_Color_Tranform_TYPE ], Scrp_Color_Tranform_bmp
ld int [ Scrp_MainProcess_TYPE ], Scrp_MainProcess_bmp
endasm

end if

asm
;����ͷ�ļ�������д��λ��
call [ Scrp_SaveAs_TYPE ]

ret


	;//=============һ�������ɫ�������=================//
	Scrp_OnePixel_Proc:
	
	;�����ǵ����~
	;��һ��ŵ��˳�ʼ���д���
	;'ld int [ Scrp_Paramater_1 ], [ vint_ScrP_page ]
	ld int [ Scrp_Paramater_2 ], [ vint_ScrP_x ]
	;��һ���Ѿ��ŵ�����ѭ���д��� �ӿ��ٶ�
	;' ld int [ Scrp_Paramater_3 ], [ vint_ScrP_y ]
	ld int r3, Scrp_Paramater_3
	OUT 25,0
	
	ld int r0, r3

	call Scrp_ColorCover_16Bit
	
	ld int r1, [ vint_Scrp_DataOffSet ]

	ld int [ r1 ], r0

	ret


;//=============����һ�εĹ���=================//
Scrp_OnePixel_Save_Proc:

ld int r1, [ vint_ScrP_y ]

;'if ( ScrP_y mod PreLine ) = 0 then
cal int mod r1, [ vint_Scrp_Save_PreLine ]
cmp int r1, 0
jpc NZ Scrp_Main_Save_EndIf:

;��ʱָ������һ������Ϊ����β�ĳ��ȣ�����д��0�ں����ֹ����
ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 0

;����
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, Scrp_Catch

out 51, 18

;��������ָ��
ld int [ vint_Scrp_DataOffSet ], Scrp_Catch


;ָ���һ�ֽ�
; loc( 1) - 1
ld int r3, [ vint_ScrP_FileHandle ]
out 54, 0

;seek
ld int r2, [ vint_ScrP_FileHandle ]
cal int add r3, - 1
out 55, 16

;'end if
Scrp_Main_Save_EndIf:


ret

;//=============��Ҫ�Ľ�ͼ����----LIB=================//
Scrp_MainProcess_LIB:



;'�������ѭ�����д��������ģ�����ȫ�������

;'��������ǽ�ͼ���ο��ƫ��
cal int add [ vint_ScrP_Hgt ], [ vint_ScrP_src_y ]
cal int add [ vint_ScrP_wid ], [ vint_ScrP_src_x ]

;'ScrP_y = src_y 
;'while ScrP_y < Hgt

ld int [ vint_ScrP_y ], [ vint_ScrP_src_y ]

;' while ScrP_Y < Hgt
Scrp_Main_Y_Bend_LIB:
cmp int [ vint_ScrP_Y ], [ vint_ScrP_Hgt ]
jpc AE Scrp_Main_Y_Wend_LIB:


	;'ScrP_x = src_x 
	ld int [ vint_ScrP_x ], [ vint_ScrP_src_x ]
	
	; 'while ScrP_x < Wid
	Scrp_Main_X_Bend_LIB:
	cmp int [ vint_ScrP_x ], [ vint_ScrP_wid ]
	jpc AE Scrp_Main_X_Wend_LIB:
	

	call Scrp_OnePixel_Proc:
	
	;'����ƫ��+2
	cal int add [ vint_Scrp_DataOffSet ], 2
	; 'ScrP_x ++
	cal int add [ vint_ScrP_x ], 1
	
	;'Wend
	jmp Scrp_Main_X_Bend_LIB:
	Scrp_Main_x_Wend_LIB:


;'ScrP_y = ScrP_y + 1

cal int add [ vint_ScrP_y ], 1
;'���־��� Srcp_Y�Ƕ���ĸо�
;'������ֵ
ld int [ Scrp_Paramater_3 ], [ vint_ScrP_y ]


;'�ж��Ƿ񴢴�
call Scrp_OnePixel_Save_Proc:

;'wend
jmp Scrp_Main_Y_Bend_LIB:
Scrp_Main_Y_Wend_LIB:


call Scrp_MainProcess_Last:

ret


;//=============��Ҫ�Ľ�ͼ����----BMP=================//
Scrp_MainProcess_BMP:



;'�������ѭ�����д��������ģ�����ȫ�������

;'bmp 4bit  ����
ld int [ scrp_i ], [ vint_ScrP_wid ]
cal int mod [ scrp_i ], 2

;'��������ǽ�ͼ���ο��ƫ��
cal int add [ vint_ScrP_Hgt ], [ vint_ScrP_src_y ]
cal int add [ vint_ScrP_wid ], [ vint_ScrP_src_x ]


;'ScrP_y = src_y
;'while ScrP_y < Hgt

ld int [ vint_ScrP_y ], [ vint_ScrP_Hgt ]
;'����
cal int add [ vint_ScrP_y ], - 1

;' while ScrP_Y < Hgt
Scrp_Main_Y_Bend_BMP:
cmp int [ vint_ScrP_Y ], [ vint_ScrP_src_y ]
jpc BE Scrp_Main_Y_Wend_BMP:


	;'ScrP_x = src_x 
	ld int [ vint_ScrP_x ], [ vint_ScrP_src_x ]
	
	; 'while ScrP_x < Wid
	Scrp_Main_X_Bend_BMP:
	cmp int [ vint_ScrP_x ], [ vint_ScrP_wid ]
	jpc AE Scrp_Main_X_Wend_BMP:
	
	
	
	call Scrp_OnePixel_Proc:

	;'����ƫ��+2
	cal int add [ vint_Scrp_DataOffSet ], 2
	; 'ScrP_x ++
	cal int add [ vint_ScrP_x ], 1
	
	;'Wend
	jmp Scrp_Main_X_Bend_BMP:
	Scrp_Main_x_Wend_BMP:

cmp int [ scrp_i ], 0
jpc z Scrp_BMP_Spc_Deal_End:

ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 65535
cal int add [ vint_Scrp_DataOffSet ], 2

Scrp_BMP_Spc_Deal_End:

;'ScrP_y = ScrP_y + 1
cal int add [ vint_ScrP_y ], - 1
;'���־��� Srcp_Y�Ƕ���ĸо�
;'������ֵ
ld int [ Scrp_Paramater_3 ], [ vint_ScrP_y ]


;'�ж��Ƿ񴢴�
call Scrp_OnePixel_Save_Proc:

;'wend
jmp Scrp_Main_Y_Bend_BMP:
Scrp_Main_Y_Wend_BMP:


call Scrp_MainProcess_Last:

ret

;//==============ɨβ����=================//
Scrp_MainProcess_Last:
;'����ɨβ���� ���ܻ�����һ����Ч�ַ�
;�����дһ��
ld int r1, [ vint_Scrp_DataOffSet ]
ld int [ r1 ], 0
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, Scrp_Catch

out 51, 18

;�ر��ļ�
out 49, [ vint_ScrP_FileHandle ]

ret


Scrp_SaveAs_LIB:
;=================================
;======//�ļ���ʼ��������//=======
;=================================
;Ϊ�˼�������µĽ�ͼ���Ƿ����ļ�ĩβ
;���ļ�
;open
ld int r0, 1
ld int r1, [ vint_ScrP_FileHandle ]
ld int r3, [ vstr_ScrP_FileName ]
out 48, 0

;����Ҫ˵���£������ɵ�lib�У�����ǰ��Ԥ��λ�ӣ����Ž�ͼ�ġ�Ԥ���Ķ���Ҳ���ǿ�
;�ʼ�յ�lib�ж��
;��ȡһ���ж���ͼƬ
;get #, Scrp_i
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
out 50, 16
ld int [ Scrp_i ], r3

;û���ļ���ʱ�� r3 < 0
;�����������û��lib�ļ����������Ϊ����ֻ��ǰ����һ��οյĲ��ܴ�����ͼ



;seek #, 0
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 0
out 55, 16

;������ĺ��������
cal int add [ Scrp_i ], 1
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ Scrp_i ]
out 51, 16

;��ȡ�ļ�����
;lof
ld int r3, [ vint_ScrP_FileHandle ]
out 53, 0
ld int [ Scrp_j ], r3

;seek #, ��ǰ�ŵ�ƫ��λ��
cal int mul [ Scrp_i ], 4

ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, [ Scrp_i ]
out 55, 16


;����ƫ��
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ Scrp_j ]
out 51, 16



;�ƶ����ļ�ĩβ
;seek #, ��ǰ�ŵ�ƫ��λ��
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, [ Scrp_j ]
out 55, 16

;�����ļ�ͷ
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 153612
out 51, 16

;�����С
ld int [ Scrp_Init_Bit1 ], [ vint_ScrP_wid ]
ld int [ Scrp_Init_Bit2 ], [ vint_ScrP_hgt ]
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, [ Scrp_Init_Bit1 ]
out 51, 16

;ָ�� + 8
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

;���ڵ��ļ�ƫ�ƾ��Ǹ�д���ļ��ĵط���ScrP_FileOffset
ld int r3, [ vint_ScrP_FileHandle ]
out 53, 0
ld int [ vint_ScrP_FileOffset ], r3

ret

;//===========�洢ΪBMP�ļ�===============//
;����ͷ�ļ�
Scrp_SaveAs_BMP:
;open
ld int r0, 1
ld int r1, [ vint_ScrP_FileHandle ]
ld int r3, [ vstr_ScrP_FileName ]
out 48, 0

'BM
;put
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 19778
out 51, 16

;seek #, 2
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 2
out 55, 16

;'�����ļ���С   һ����С����scrp_i������Ҫʹ��
ld int r1, [ vint_ScrP_wid ]
ld int r3, [ vint_ScrP_hgt ]

cal int mul r3, r1
cal int mul r3, 2

ld int [ scrp_i ], r3

cal int add r3, 54
;����
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647

out 51, 16
;'����BBMP ��Ϊ�����ļ��ı�ʶ
ld int r3, 1347240514
out 51, 16

;'�����׼��ͷ�ļ�����
ld int r3, 54
out 51, 16

;'�����׼��ͷ�ļ���С
ld int r3, 40
out 51, 16

;'�����
ld int r3, [ vint_ScrP_wid ]
out 51, 16

;'�����
ld int r3, [ vint_ScrP_Hgt ]
out 51, 16

;'����һЩ������Ϣ ���ֻռ2byte
ld int r3, 1
out 51, 16

;seek #, 28
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 28
out 55, 16

;'������ɫ��ʽ 16bit ���ֻռ2byte
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 16
out 51, 16

;seek #, 30
ld int r2, [ vint_ScrP_FileHandle ]
ld int r3, 30
out 55, 16

;'����ѹ������ ��ѹ��
ld int r1, [ vint_ScrP_FileHandle ]
ld int r2, 2147483647
ld int r3, 0
out 51, 16

;'����ͼ�����ݳ���
ld int r3, [ scrp_i ]
out 51, 16

;'����
ld int r3, 2834
out 51, 16

;'����
ld int r3, 2834
out 51, 16

;'����
ld int r3, 0
out 51, 16

;'����
out 51, 16

ret
Scrp_QingWuShi:
endasm


