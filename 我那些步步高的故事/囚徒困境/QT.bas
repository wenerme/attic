'��Ϣ����
const SYS_WaitMessage = &h00
const SYS_GameOver = 	&h01
const SYS_GameWin = 	&h02
const SYS_GameFailed = 	&h03
const SYS_GameDraw = 	&h04
const SYS_GameING = 	&h05
const SYS_GameQuit =	&h06


'�˵�
const Menu_gameStart = 	&h101
const Menu_help = 	&h102
const Menu_about = 	&h103
const Menu_quit = 	&h104
'����¼�
const User_Event = 	&h200
const User_cooperate = 	&h201
const User_defect = 	&h202

const User_Change_Times = &h203

'//�����Ķ���
'==//����ͼƬ
const Text_Clean = &hffffffff	'-1
const Text_AnyKeyReturn = 0
const Text_AnyKeyStart = 1
const Text_SetTimes = 2
const Text_SetConfirm = 3
const Text_QuitConfirm = 4
const Text_ReStartConfirm = 5
const Text_WaitPlayer = 6


 




'���е�ͼƬ���
dim g_pic_bg, g_pic_Point, g_pic_Times, g_pic_gameHelp, g_pic_gameAbout, g_pic_text, g_pic_SelectedBox

'����ҳ����
dim g_pg_ZK 'ս����ҳ��
dim g_pg_buff, g_pg_temp

dim G_User_Inkey
dim g_gameState

'��ֵ����
Dim G_key_x, G_key_y
Dim G_key_up, G_key_down, G_key_left, G_key_right
DIM G_key_escape, G_key_enter
Dim G_touch_x, G_touch_y	'�������X Y
Dim G_touch_ID	'���������idֵ

Dim G_Event_Id
'//==��Ϸ����
DIM G_User_points, G_Wen_points, G_CurrentGate, G_AllGate, G_User_CurPoints, G_Wen_CurPoints, G_User_LastChoice
Dim G_User_Choice, G_Wen_Choice, G_str_OP$( 2)'�����ַ�������
Dim G_ShowText_ID
'ͳ��
Dim G_User_ChoiceCount( 2)

'����ȫ�ֱ���
dim fe$, res_file_name$, temp_data, temp_Boolean
'//==��������
declare function ShowNum( hPage, hImg, x, y, num)
declare function getInput()
declare function calTouchId()

declare function random( range)
declare function TriggerEvent( probability)

declare function ShowPlayerPoints( num)
declare function ShowWenPoints( num)
declare function ShowCurrentGate( num)
declare function ShowAllGate( num)
declare function ShowText( hPage, num)


declare function render()
declare function setTimes()
declare function Confirm( num)
declare function GameProcess()
declare function ZKDeal( ZKStr$, ShowPoint) '����ս������ʾ
declare function ZKClean()

declare function WenProcess() 'AI����
declare function PointProcess()
'declare function GateProcess()
declare function TimesOut()

declare function iSTRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC) 'һ������Ӧ��bug�ĺ��� ����ҳ���õ� iSTRETCHBLTPAGEEX_Buff

iSTRETCHBLTPAGEEX_Buff = createpage()

setlcd( 240, 320)

IF GetEnv!() = Env_SIM Then
	fe$ = ".rlb"
Else
	fe$ = ".lib"
End IF

'//��ʼ��
res_file_name$ = "QT_res" + fe$
g_pic_bg = Loadres( res_file_name$, 1)
g_pic_Times = Loadres( res_file_name$, 2)
g_pic_Point = Loadres( res_file_name$, 3)
g_pic_gameHelp = Loadres( res_file_name$, 4)
g_pic_gameAbout = Loadres( res_file_name$, 5)
g_pic_text = Loadres( res_file_name$, 6)
g_pic_SelectedBox = Loadres( res_file_name$, 7)
g_pic_Click = Loadres( res_file_name$, 8)

g_pg_ZK = createpage()
g_pg_buff = createpage()
g_pg_temp = createpage()

G_User_points = 0
G_Wen_points = 0
G_CurrentGate = 1
G_AllGate = 5

'���Ժ�����ʼ
G_User_LastChoice = User_cooperate

G_str_OP$( 0) = "����"
G_str_OP$( 1) = "����"

G_ShowText_ID = Text_AnyKeyStart

'�������� 103 48
SETBKMODE( TRANSPARENT)

'//===��ѭ��===


g_gameState = SYS_WaitMessage
while 1


render()

ShowText( g_pg_buff, G_ShowText_ID)

if g_gameState = SYS_GameING or g_gameState = SYS_GameOver then
	STRETCHBLTPAGEEX( 100, 48, 140, 195, 0, 0, g_pg_buff, G_PG_ZK)
end if

flippage( g_pg_buff)



G_User_Inkey = waitkey()

'ZKDeal( "NOW:" + gettick() )


getinput()

'����Ч��Ϣʱ
if G_touch_ID <> - 1 then

'��Χ
if G_touch_ID < &h200 and G_touch_ID > &h100 then
	'�˵�
	if G_touch_ID = Menu_gameStart then
		
		if g_gameState <> SYS_GameING then
			
			g_gameState = SYS_GameING
			
			G_User_points = 0
			G_Wen_points = 0
			G_CurrentGate = 1			
			
			ZKClean()
			ZKDeal( "��ʼ��Ϸ����" + G_AllGate + "��", 0)
			
			G_ShowText_ID = Text_WaitPlayer
		else if confirm( Text_ReStartConfirm) then
		
			g_gameState = SYS_GameING
			'���¿�ʼ
			G_User_points = 0
			G_Wen_points = 0
			G_CurrentGate = 1
			
			ZKClean()
			
			ZKDeal( "��ʼ��Ϸ����" + G_AllGate + "��", 0)
			
			G_ShowText_ID = Text_WaitPlayer
			
		end if

		
	else if G_touch_ID = Menu_help  then
		showpic( -1, g_pic_gameHelp, 99, 48, 141, 157, 0, 0, 1)
		
		ShowText( - 1, Text_AnyKeyReturn)
		waitkey()
	else if G_touch_ID = Menu_about then
		showpic( -1, g_pic_gameHelp, 99, 47, 141, 159, 0, 0, 1)
		
		ShowText( - 1, Text_AnyKeyReturn)
		waitkey()
	else if G_touch_ID = Menu_quit then
		if confirm( Text_QuitConfirm) then
			g_gameState = SYS_GameQuit
			
			color( &h5167fb, 0, 0)
			
			ZKClean()
			ZKDeal( "��Ϸ���ߣ�Wener", 0)
			ZKDeal( "��̳Id��a3160586", 0)
			ZKDeal( "��ӭ����", 0)
			ZKDeal( "   club.eebbk.com", 0)
			ZKDeal( "      �ڴ���������", 0)
			
			msdelay( 1500)
			
			end
		end if
		
	end if
'�û�������Χ
else if G_touch_ID < &h300 and G_touch_ID > &h200 then
	
	if G_touch_ID = User_cooperate or G_touch_ID = User_defect and g_gameState = SYS_GameING then
		'�������User_Event ���Ǻ���Ϊ1 ����Ϊ2
		G_User_Choice = G_touch_ID '- User_Event
		
		'�ĵĴ������
		WenProcess()
		
		'���ֹ���
		PointProcess()
		
		ZKDeal( "", 1)
		
		'�ؿ��������
		'GateProcess()
		
		'������� �������ʤ���ж�
		TimesOut()
		
		
	
	else if G_touch_ID = User_Change_Times then
	
		SetTimes()

	end if
end if

end if


wend

'//==�������嶨��==

'//Wen�Ĵ������ AI����
function WenProcess() 
DIM shared G_User_points, G_Wen_points, G_CurrentGate, G_AllGate, G_User_CurPoints, G_Wen_CurPoints
Dim shared G_User_Choice, G_Wen_Choice, G_User_LastChoice

Dim shared G_User_ChoiceCount( 2)

dim shared WenProcess_CoTime, WenProcess_DeTime, WenProcess_Pro



WenProcess_CoTime = G_User_ChoiceCount( 0)
WenProcess_DeTime = G_User_ChoiceCount( 1)


if ( WenProcess_DeTime > WenProcess_CoTime and TriggerEvent( 30 )) then
	

	G_Wen_Choice = User_cooperate
	
else if ( WenProcess_DeTime < WenProcess_CoTime and TriggerEvent( 50 )) then

	G_Wen_Choice = User_Defect

else 
	'������������
	G_Wen_Choice = G_User_LastChoice
	
end if


' - User_cooperate ��Ϊ�˱�֤ ����Ϊ0 ����Ϊ1	
'���� ����֪���û�ѡ��ģ����Ա��δ����ʱ�򲢲�֪���û�ѡ��
G_User_ChoiceCount( G_User_Choice - User_cooperate) = G_User_ChoiceCount( G_User_Choice - User_cooperate)  + 1

G_User_LastChoice = G_User_Choice

end function

'//�����������
function PointProcess()

	'wen���� ��Һ���
	if G_Wen_Choice > G_User_Choice then
		
		G_User_CurPoints = 0
		G_Wen_CurPoints  = 5
	'��ͬѡ��
	else if G_Wen_Choice = G_User_Choice then
		
		'ͬʱ����
		if G_Wen_Choice = User_cooperate then
		
			G_User_CurPoints = 3
			G_Wen_CurPoints  = 3
		'ͬʱ����
		else if G_Wen_Choice = User_Defect then

			G_User_CurPoints = 1
			G_Wen_CurPoints  = 1
		'�쳣
		else 
			ZKDeal( "�����쳣 ���ֹ��̳���", 0)
		end if
	'��ұ��� wen����
	else
		G_User_CurPoints = 5
		G_Wen_CurPoints  = 0	
				
	end if
	
'��������
G_User_points = G_User_points + G_User_CurPoints
G_Wen_points = G_Wen_points + G_Wen_CurPoints

end function

'//�ִμ�������ʤ�������ж�
function TimesOut()

G_CurrentGate = G_CurrentGate + 1
'��Ϸ����
if G_AllGate = G_CurrentGate - 1 then
	
	color( &h5167fb, 0, 0)
	
	if G_Wen_Points > G_User_Points then
		
		ZKDeal( "ʧ���ˣ�����һ�ΰɣ�", 0 )
		g_gameState = SYS_WaitMessage
		
	else if G_Wen_Points < G_User_Points then
	
		ZKDeal( "ʤ�������������Ŷ��", 0 )
		g_gameState = SYS_WaitMessage
		
	else

		ZKDeal( "ƽ��Ү������һ�ΰɣ�", 0 )
		g_gameState = SYS_WaitMessage
		
	end if

	color( &hffffff, 0, 0)
	'���-1��Ϊ��֮�����ȷ��ʾ
	G_CurrentGate = G_CurrentGate - 1
	g_gameState = SYS_GameOver
	
	G_ShowText_ID = Text_AnyKeyStart
end if
	


end function

'//��ȡ�����
function random( range)
	RANDOMIZE( gettick())
	random = rnd( range)
	'ȷ���������
	msdelay( 10)
end function

'//��������¼� 
'probability Ϊ 100����  �����˷���1 ���򷵻�0
function TriggerEvent( probability)
	if random( 100) < probability then
		TriggerEvent = 1
	else
		TriggerEvent = 0
	end if
end function

'//��ʾ��ҷ���
function ShowPlayerPoints( num)
	ShowNum( g_pg_buff, g_pic_Point, 55, 34, num)
end function
'//��ʾWen�ķ���
function ShowWenPoints( num)
	ShowNum( g_pg_buff, g_pic_Point, 55, 97, num)
end function
'//��ʾ��ǰ�ִ�
function ShowCurrentGate( num)
	ShowNum( g_pg_buff, g_pic_Times, 54, 215, num)
end function
'//��ʾ�ִܾ�
function ShowAllGate( num)
	ShowNum( g_pg_buff, g_pic_Times, 78, 215, num)
end function

'//��Ⱦ
function render()
	showpic( g_pg_buff, g_pic_bg, 0, 0, 240, 320, 0, 0, 1)
	ShowPlayerPoints( G_User_points)
	ShowWenPoints( G_Wen_points)
	
	ShowCurrentGate( G_CurrentGate)
	ShowAllGate( G_AllGate)

end function
'//���ô���
function setTimes()

ShowText( - 1, Text_SetTimes )
showpic( - 1, g_pic_SelectedBox, 61, 214, 18, 18, 0, 0, 1)
ShowNum( -1, g_pic_Times, 78, 215, G_AllGate)

temp_data = G_AllGate
temp_Boolean = 1
	
	
while temp_Boolean
	G_User_Inkey = waitkey()
	getinput()
	
'==//��Ч��Ϣ�Ŵ���
if G_User_Inkey > 0 then
	
	'�����ж�
	if G_key_up or G_key_down then
		temp_data = temp_data + G_key_up - G_key_down
	else if G_key_left or G_key_right then
		temp_data = temp_data + G_key_left * 3 - G_key_right * 3
		
	else if G_key_escape or G_key_enter then
		'ȷ��
		if G_key_enter then
			G_AllGate = temp_data
		end if
		
		temp_Boolean = 0
	
	end if
	
	'�ִν綨 G_CurrentGate-30  g_gameState = SYS_GameING
	if temp_data < G_CurrentGate + 1 then
		temp_data = G_CurrentGate + 1
	else if temp_data > 30 then
		temp_data = 30
	end if
	
	
	showpic( - 1, g_pic_bg, 62, 215, 16, 13, 62, 215, 1)
	ShowNum( -1, g_pic_Times, 78, 215, temp_data)
	
	
'==//�����Ļ����λ�õ�ʱ��ȷ��  ���ǵ�֮ǰ���Ǹ�λ�� �����и��ж�
else if G_touch_ID <> User_Change_Times then
	temp_Boolean = 0
	
	if confirm( Text_SetConfirm) then
		G_AllGate = temp_data
	end if
	ShowText( - 1, Text_SetConfirm)
	
end if
	
wend
	
	
end function

'//��ʾ����ͼƬ
function ShowNum( hPage, hImg, x, y, num)

dim shared ShowNum_at_x, ShowNum_at_y, ShowNum_pic_wid, ShowNum_pic_heg, ShowNum_cur_num, ShowNum_num
dim shared ShowNum_hPage, ShowNum_hImg, ShowNum_i

ShowNum_hPage = hPage
ShowNum_hImg = hImg

ShowNum_at_x = x
ShowNum_at_y = y


ShowNum_pic_wid = getpicwid( himg) / 10
ShowNum_pic_heg = getpichgt( himg)

ShowNum_num = num
if ShowNum_num = 0 then
	showpic( ShowNum_hPage, ShowNum_hImg, ShowNum_at_x, ShowNum_at_y, ShowNum_pic_wid, ShowNum_pic_heg, 0, 0, 1)
else
	while ShowNum_num

		ShowNum_cur_num =  ShowNum_num mod 10
		ShowNum_at_x = ShowNum_at_x - ShowNum_pic_wid
		
		showpic( ShowNum_hPage, ShowNum_hImg, ShowNum_at_x, ShowNum_at_y, ShowNum_pic_wid, ShowNum_pic_heg, ShowNum_cur_num * ShowNum_pic_wid, 0, 1)
	
	ShowNum_num = ShowNum_num / 10
	wend
end if

end function

'//��ʾ����ͼƬ
function ShowText( hPage, num)

if num >= 0 then
	showpic( hPage, g_pic_text, 0, 258, 240, 20, 0, 20 * num, 1)
else'�ָ�
	showpic( hPage, g_pic_bg, 0, 258, 240, 20, 0, 258, 1)
end if
end function

'//��Ϸ����
function GameProcess()

dim shared GameProcess_state



end function
'//ս���Ĵ��� ���ShowPoint Ϊ��������ʾ���� ��ʱZKstr$ֵ��Ч
function ZKDeal( ZKstr$, ShowPoint)

dim shared ZKDeal_PrintLine, ZKDeal_scrollMode, ZKDeal_Temp_Str$, G_PG_temp

if ZKDeal_scrollMode then

	'STRETCHBLTPAGEEX( 0, - 13, 140, 195, 0, 0, G_PG_ZK, G_PG_ZK)
	'STRETCHBLTPAGEEX( 100, 48, 140, 182, 0, 0, - 1, G_PG_ZK)
	'��������
	iSTRETCHBLTPAGEEX( 0, - 5, 140, 195, 0, 0, G_PG_temp, G_PG_ZK)
	iSTRETCHBLTPAGEEX( 100, 48, 140, 182, 0, 0, - 1, G_PG_temp)
	msdelay( 100)
	iSTRETCHBLTPAGEEX( 0, - 9, 140, 195, 0, 0, G_PG_temp, G_PG_ZK)
	iSTRETCHBLTPAGEEX( 100, 48, 140, 182, 0, 0, - 1, G_PG_temp)
	msdelay( 100)
	iSTRETCHBLTPAGEEX( 0, - 12, 140, 195, 0, 0, G_PG_temp, G_PG_ZK)
	iSTRETCHBLTPAGEEX( 100, 48, 140, 182, 0, 0, - 1, G_PG_temp)
	msdelay( 100)
	iSTRETCHBLTPAGEEX( 0, - 13, 140, 195, 0, 0, G_PG_ZK, G_PG_ZK)
	iSTRETCHBLTPAGEEX( 100, 48, 140, 182, 0, 0, - 1, G_PG_ZK)
end if

pixlocate( 100 , 48 + 13 * ZKDeal_PrintLine )

'������ʾ �û���ǲ���㷱�ӵĶ�λ
if ShowPoint = 1 then
	ZKDeal_Temp_Str$ = "���"
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &h8eeff8, 0, 0)
	ZKDeal_Temp_Str$ = g_str_OP$( G_User_Choice - User_cooperate)
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &hffffff, 0, 0)
	ZKDeal_Temp_Str$ = "����"
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &h3ec68b, 0, 0)
	
	ZKDeal_Temp_Str$ = g_str_OP$( G_Wen_Choice - User_cooperate)
	
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &hffffff, 0, 0)
	
	
	
'��ʾ�����ĵڶ��׶�
else if ShowPoint = 2 then

	ZKDeal_Temp_Str$ = "��ҵ÷�"
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &h8eeff8, 0, 0)
	ZKDeal_Temp_Str$ = g_str_OP$( G_User_Choice - User_cooperate)
	vasm(" out 3, [ Vint_g_User_CurPoints]")
	
	color( &hffffff, 0, 0)
	ZKDeal_Temp_Str$ = "���ĵ÷�"
	vasm(" out 2, [ Vstr_ZKDeal_Temp_Str]")
	
	color( &h3ec68b, 0, 0)
	
	ZKDeal_Temp_Str$ = g_str_OP$( G_Wen_Choice - User_cooperate)
	
	vasm(" out 3, [ Vint_g_Wen_CurPoints]")
	
	color( &hffffff, 0, 0)
	
	'������������дҲ����ȷ�� ���ǲ�֪��Ϊʲô�����ʱ����ʱ�����~
'	print "��ҵ÷�:";
	
'	color( &h3ec68b, 0, 0)
'	print g_User_CurPoints; 
	
'	color( &hffffff, 0, 0)
'	print "�ĵ÷�";
	
'	color( &h3ec68b, 0, 0)
'	print g_Wen_CurPoints; 	
	
'	color( &hffffff, 0, 0)
	
else

print ZKstr$

end if

if ZKDeal_scrollMode then

	iSTRETCHBLTPAGEEX( 0, 169, 140, 26, 100, 217, G_PG_ZK, -1)
	
else
	iSTRETCHBLTPAGEEX( 0, 0, 140, 195, 100, 48, G_PG_ZK, -1)
	ZKDeal_PrintLine = ZKDeal_PrintLine + 1
	
	if ZKDeal_PrintLine > 13 then
		
		iSTRETCHBLTPAGEEX( 0, 169, 140, 26, 100, 217, G_PG_ZK, -1)

		ZKDeal_scrollMode = 1
		ZKDeal_PrintLine = 13
	end if

end if

'������ݹ���ǶԵ�
if ShowPoint = 1 then
	ZKDeal( "", 2)
end if

end function

'//���ս�����
function ZKClean()
dim shared ZKDeal_PrintLine, ZKDeal_scrollMode
	
	ZKDeal_PrintLine = 0
	ZKDeal_scrollMode = 0
	
	showpic( G_PG_ZK, g_pic_bg, 0, 0, 140, 195, 100, 48, 1)
	showpic( -1, g_pic_bg, 100, 48, 140, 195, 100, 48, 1)

end function

'//��ȡ������Ϣ
function getInput()

'==/////===========����
if G_User_Inkey < 0 then
	G_touch_x = getpenposx( G_User_Inkey)
	G_touch_y = getpenposy( G_User_Inkey)
	G_touch_id = -1
	calTouchId() '���㴥��
	
else
	G_touch_x = -1
	G_touch_y = -1
	G_touch_id = -1
end if
'==/////=========== �����
VASM("LD INT r3,38") '//==UP
VASM("OUT 34,0")
VASM("LD INT [VINT_G_key_up],r3")

VASM("LD INT r3,40") '//==DOWN
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Down],r3")

VASM("LD INT r3,37") '//==left
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Left],r3")

VASM("LD INT r3,39") '//==right
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Right],r3")
'//==============������
VASM("LD INT r3,13") '//==ENTER
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Enter],r3")

VASM("LD INT r3,27") '//==ESCAPE
VASM("OUT 34,0")
VASM("LD INT [VINT_G_Key_Escape],r3")

end function

'//���㴥����Id
function calTouchId()

'�˵���
if G_touch_y > 297 and G_touch_x > 10 and G_touch_x < 126 and G_touch_y < 311 then

	if G_touch_x < 34 then
		G_touch_id = Menu_gameStart
		
		showpic( - 1, g_pic_Click, 8, 296, 28, 14, 8, 16, 1)
		
	else if G_touch_x < 64 then
		G_touch_id = Menu_help
		
		showpic( - 1, g_pic_Click, 40, 296, 26, 14, 40, 16, 1)
		
	else if G_touch_x < 94 then
		G_touch_id = Menu_about
		
		showpic( - 1, g_pic_Click, 70, 296, 26, 14, 70, 16, 1)
		
	else if G_touch_x < 126 then
		G_touch_id = Menu_quit
		
		showpic( - 1, g_pic_Click, 101, 296, 26, 14, 101, 16, 1)
		
	end if

'���ѡ��
else if G_touch_y > 280 and G_touch_x > 145 then
	
	if G_touch_x < 192 then
		G_touch_id = User_cooperate 
		
		showpic( - 1, g_pic_Click, 143, 280, 50, 40, 143, 0, 1)
		
	else 
		G_touch_id = User_defect
		
		showpic( - 1, g_pic_Click, 194, 280, 56, 40, 194, 0, 1)
	end if
'ѡ�����
else if G_touch_x > 63 and G_touch_y > 215 and G_touch_x < 79 and G_touch_y < 228 then

	G_touch_id = User_Change_Times
	
end if
	

end function

'//ȷ������
function Confirm( num)

dim shared SetConfirm_inkey, SetConfirm_inkey_x, SetConfirm_inkey_y, SetConfirm_return

ShowText( - 1, num)

SetConfirm_return = -1

while SetConfirm_return = -1
	
	SetConfirm_inkey = waitkey()
	
	'��������Ϊ��ȷ����������Ķ�������Ӱ��������ĺ���	
	if SetConfirm_inkey < 0 then
	
	SetConfirm_inkey_x = getpenposx( SetConfirm_inkey)
	SetConfirm_inkey_y = getpenposy( SetConfirm_inkey)
		if SetConfirm_inkey_y > 258 and SetConfirm_inkey_y < 278 then
		
			if SetConfirm_inkey_x > 141 and SetConfirm_inkey_x < 182 then
			
				SetConfirm_return = 1
			
			else if SetConfirm_inkey_x > 188 and SetConfirm_inkey_x < 229 then
			
				SetConfirm_return = 0
			
			end if
		
		end if
		
	else if SetConfirm_inkey = KEY_ENTER then
		
		SetConfirm_return = 1
		
	else if SetConfirm_inkey = KEY_ESCAPE then
	
		SetConfirm_return = 0
		
	end if
	
wend

Confirm = SetConfirm_return

end function

'//����bug�ĺ���
function iSTRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)

dim shared iSTRETCHBLTPAGEEX_Buff

if SRC = - 1 then

	BITBLTPAGE( iSTRETCHBLTPAGEEX_Buff, -1)
	STRETCHBLTPAGEEX( X,Y,WID,HGT,CX,CY,DEST, iSTRETCHBLTPAGEEX_Buff )
else
	STRETCHBLTPAGEEX(X,Y,WID,HGT,CX,CY,DEST,SRC)
end if

end function























