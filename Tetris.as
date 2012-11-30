package 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	public dynamic class Tetris extends Sprite 
	{
		private var msg:TextField = new TextField  ;
		var counter:int = 0;
		var shapes:Array = new Array();
		var boards:Array = new Array();
		var chunk:int = -1;
		var chunk_x:int;
		var chunk_y:int;
		var chunk_next:int = -1;
		private var contain:Sprite;
		private var bmd:BitmapData = new BitmapData(10,10,true,0xffFF9900);
		private var bm:Bitmap;
		var timer:Timer;
		var game_state:int = 2;

		const evt_type_timer:int = 0;
		const evt_type_keydown:int = 1;

		public function Tetris()
		{
			trace("Tetris start()");

			init_shapes();
			contain = new Sprite();
			msg.text  = "click to start!"
			msg.x = 220;
			msg.y = 180;
			if (contains(msg))
			{
				removeChild(msg);
			}
			
			addChild(msg);
			msg.addEventListener (MouseEvent.CLICK,click_handler);
			
			/*
			
*/
		}
		private function click_handler(evt:MouseEvent) {
			init_boards();
			game_state = 1;
			timer = new Timer(500,22);
			show_counter(0);
			trace("len of shapes = " + shapes.length);
			timer.addEventListener(TimerEvent.TIMER, main_loop);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keydown_handler);
			timer.start();
			
		}
		private function init_boards()
		{
			if (contains(contain))
			{
				removeChild(contain);
			}
			contain = new Sprite();
			boards = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
			counter = 0;
			chunk = -1;
			chunk_next = Math.random() * 19;
		}
		private function show_boards():void
		{
			if (contains(contain))
			{
				removeChild(contain);
			}
			contain = new Sprite();
			
			var ret = check_chunk(evt_type_timer,0);
			if (ret == 1)
			{
				ret = flash_borads();
				chunk = -1;
			}
			else  
			{
				put_chunk(0);
			}

			show_shape(chunk_next);
			for (var i:int = 0; i < 10; ++i)
			{
				for (var j:int = 0; j < 20; ++j)
				{
					if (boards[i][j] == 1)
					{
						bm = new Bitmap();
						bm.bitmapData = bmd;
						bm.x = i * 10;
						bm.y = j * 10;
						contain.addChild(bm);
					}
				}
			}
			bm = new Bitmap(new BitmapData(1,200,true,0xffFFFF00));
			contain.addChild(bm);
			bm = new Bitmap(new BitmapData(100,1,true,0xffFFFF00));
			bm.y = 200;
			contain.addChild(bm);
			bm = new Bitmap(new BitmapData(1,200,true,0xffFFFF00));
			bm.x = 100;
			contain.addChild(bm);

			contain.x = 160;
			contain.y = 60;
			this.addChild(contain);

		}
		private function remove_line(line:int):int
		{
			if (line < 0)
			{
				return 0;
			}
			var counter:int = 0;
			counter += remove_line(line - 1);

			var flag:int = 0;
			for (var i:int = 0; i < 10; ++i)
			{
				if (boards[i][line] == 0)
				{
					flag = 1;
					break;
				}
			}
			if (flag == 0)
			{
				if (line == 0)
				{
					for (i  = 0; i < 10; ++i)
					{
						boards[i][line] = 0;
					}
				}
				else
				{
					for (var j:int = line; j > 0; --j)
					{
						for (i = 0; i < 10; ++i)
						{
							boards[i][j] = boards[i][j - 1];
						}
					}
				}
				counter +=  1;
			}

			return counter;
		}
		private function flash_borads():int
		{
			var flag:int = 0;
			var count:int = 0;
			for (var i:int = 0; i < 4; ++i)
			{
				if (boards[chunk_x + shapes[chunk][2 * i]][chunk_y + shapes[chunk][2 * i + 1]] == 1)
				{
					flag = 1;
				}
				else
				{
					boards[chunk_x + shapes[chunk][2 * i]][chunk_y + shapes[chunk][2 * i + 1]] = 1;
				}
			}
			trace("matrix:");
			for (var j:int = 0; j  < 20; ++j)
			{
				trace(boards[0][j] + " " + boards[1][j] + " " + boards[2][j] + " " + boards[3][j] + " " + boards[4][j] + " " + boards[5][j] + " " + boards[6][j] + " " + boards[7][j] + " " + boards[8][j] + " " + boards[9][j]);
			}

			show_counter(remove_line(19));
			return flag;
		}
		private function init_shapes()
		{
			var shape0:Array = new Array(0,1,1,0,1,1,2,0,1,3);
			shapes.push(shape0);
			var shape1:Array = new Array(0,0,0,1,1,1,1,2,0,2);
			shapes.push(shape1);
			var shape2:Array = new Array(0,0,1,0,1,1,2,1,3,3);
			shapes.push(shape2);
			var shape3:Array = new Array(0,1,0,2,1,0,1,1,2,3);
			shapes.push(shape3);
			var shape4:Array = new Array(0,0,0,1,0,2,0,3,5,4);
			shapes.push(shape4);
			var shape5:Array = new Array(0,0,1,0,2,0,3,0,4,4);
			shapes.push(shape5);
			var shape6:Array = new Array(0,0,0,1,1,0,1,1,-1,2);
			shapes.push(shape6);
			var shape7:Array = new Array(0,0,1,0,1,1,2,0,8,3);
			shapes.push(shape7);
			var shape8:Array = new Array(0,0,0,1,0,2,1,1,9,2);
			shapes.push(shape8);
			var shape9:Array = new Array(0,1,1,0,1,1,2,1,10,3);
			shapes.push(shape9);
			var shape10:Array = new Array(0,1,1,0,1,1,1,2,7,2);
			shapes.push(shape10);
			var shape11:Array = new Array(0,0,0,1,0,2,1,0,12,2);
			shapes.push(shape11);
			var shape12:Array = new Array(0,0,0,1,1,1,2,1,13,3);
			shapes.push(shape12);
			var shape13:Array = new Array(0,2,1,0,1,1,1,2,14,2);
			shapes.push(shape13);
			var shape14:Array = new Array(0,0,1,0,2,0,2,1,11,3);
			shapes.push(shape14);
			var shape15:Array = new Array(0,0,1,0,1,1,1,2,16,2);
			shapes.push(shape15);
			var shape16:Array = new Array(0,0,0,1,1,0,2,0,17,3);
			shapes.push(shape16);
			var shape17:Array = new Array(0,0,0,1,0,2,1,2,18,2);
			shapes.push(shape17);
			var shape18:Array = new Array(0,1,1,1,2,0,2,1,15,3);
			shapes.push(shape18);
			shapes.push(shape0);
			shapes.push(shape1);
			shapes.push(shape2);
			shapes.push(shape3);
			shapes.push(shape4);
			shapes.push(shape5);
			shapes.push(shape6);
			shapes.push(shape6);
			shapes.push(shape6);

		}
		private function show_shape(index:int)
		{
			var i:int = 0;
			while (i < 4)
			{
				bm = new Bitmap();
				bm.bitmapData = bmd;
				//trace("shapes " + index + " x = " + shapes[index][i] + " y = " + shapes[index][i + 1]);
				bm.x = 200 + shapes[index][2 * i] * 10;
				bm.y = 100 + shapes[index][2 * i + 1] * 10;
				//trace("x = " + bm.x + " y = " + bm.y);
				contain.addChild(bm);

				i = i + 1;
			}

		}
		private function keydown_handler(evt:KeyboardEvent):void
		{

			if (chunk == -1)
			{
				return;
			}

			if (evt.keyCode == 38)
			{
				if (1 == check_chunk(evt_type_keydown,0))
				{
					return;
				}
			}
			else if (evt.keyCode == 37)
			{
				if (1 == check_chunk(evt_type_keydown,-1))
				{
					return;
				}
				chunk_x -=  1;
			}
			else if (evt.keyCode == 39)
			{
				if (1 == check_chunk(evt_type_keydown,1))
				{
					return;
				}
				chunk_x +=  1;
			}
			else if (evt.keyCode == 40)
			{
				if (1 == check_chunk(evt_type_timer,0))
				{
					return;
				}
				chunk_y +=  1;
			}
			else if (evt.keyCode == 32)
			{
				while (0 == check_chunk(evt_type_timer,0)) {
					chunk_y +=  1;
				}
			}
			show_boards();
			return ;
		}
		private function main_loop(evt:TimerEvent):void
		{

			if (chunk == -1)
			{
				chunk = chunk_next;
				chunk_next = Math.random() * 28;
				chunk_x = Math.random() * 8;
				if (chunk_x + 4 > 9) {
					chunk_x = 5;
				}
				chunk_y = 0;
				timer.reset();
				var flag:int = 0;
				for (var i:int = 0; i < 4; ++i)
				{
					if (boards[chunk_x + shapes[chunk][2 * i]][chunk_y + shapes[chunk][2 * i + 1]] == 1)
					{
						flag = 1;
					}
				}
				if (flag == 1)
				{
					game_state = 2;
					this.removeEventListener(KeyboardEvent.KEY_DOWN,keydown_handler);
					trace("over");
				}
				else
				{
					timer.start();
				}
			}
			else
			{
				if (0 == check_chunk(evt_type_timer,0))
				{
					chunk_y +=  1;
				}
			}
			show_boards();
			return;
		}
		private function put_chunk(offset:int):int
		{
			for (var i:int = 0; i < 4; ++i)
			{
				if (chunk_y + shapes[chunk][2 * i + 1] >= 0)
				{
					bm = new Bitmap();
					bm.bitmapData = bmd;
					bm.x = (chunk_x + shapes[chunk][2 * i] + offset) * 10;
					bm.y = (chunk_y + shapes[chunk][2 * i + 1]) * 10;
					if (chunk_x + shapes[chunk][2 * i] + offset < 0 || chunk_x + shapes[chunk][2 * i] + offset > 19 )
					{
						return 1;
					}
					if (boards[chunk_x + shapes[chunk][2 * i] + offset][chunk_y + shapes[chunk][2 * i + 1]] == 1)
					{
						return 1;
					}
					contain.addChild(bm);
				}
			}

			return 0;
		}
		private function check_chunk(type:int,offset:int):int
		{
			var ret:int = 0;
			var chunk_tmp:int;
			var chunk_x_tmp:int;

			if (type == evt_type_keydown && offset == 0)
			{
				if (shapes[chunk][8] == -1) {
					return 1;
				}
				chunk_tmp = chunk;
				chunk = shapes[chunk][8];
				if (10 - chunk_x < shapes[chunk][9])
				{
					chunk_x_tmp = chunk_x;
					chunk_x = 10 - shapes[chunk][9];
				}
			}

			for (var i:int = 0; i < 4; ++i)
			{
				if (type == evt_type_timer)
				{//timer
					if (chunk_y + shapes[chunk][2 * i + 1] < 0 )
					{
						continue;
					}
					else if (chunk_y + shapes[chunk][2 * i + 1] + 1> 19)
					{
						ret = 1;
					}
					else if (boards[chunk_x + shapes[chunk][2 * i]][chunk_y + shapes[chunk][2 * i + 1] + 1] == 1)
					{
						ret = 1;
					}
				}
				else if (type == evt_type_keydown)
				{
					if (offset == 0)
					{
						if (chunk_y + shapes[chunk][2 * i + 1] < 0  || chunk_y + shapes[chunk][2 * i + 1] > 19)
						{
							ret = 1;
							break;
						}
						if (boards[chunk_x + shapes[chunk][2 * i]][chunk_y + 1 + shapes[chunk][2 * i + 1]] == 1)
						{
							ret = 1;
							break;
						}
					}
					else
					{
						if (chunk_x + shapes[chunk][2 * i] + offset < 0 || chunk_x + shapes[chunk][2 * i] + offset > 9)
						{
							ret = 1;
							break;
						}
						if (boards[chunk_x + shapes[chunk][2 * i] + offset][chunk_y + shapes[chunk][2 * i + 1]] == 1)
						{
							ret = 1;
							break;
						}
					}
				}//keydown
			}
			if (type == evt_type_keydown && offset == 0 && ret == 1)
			{
				chunk = chunk_tmp;
				chunk_x = chunk_x_tmp;
			}
			return ret;
		}
		private function show_counter(add_num:int):void
		{
				counter +=  add_num;
				msg.text = "score : " + counter;
				if (game_state == 2) {
					msg.appendText( "\nGame Over\nclick here to restart");
				}
				msg.x = 360;
				msg.y = 200;
				if (contains(msg))
				{
					removeChild(msg);
				}
				addChild(msg);
				timer.delay = 500 - (counter / 10) * 100;
		}
	}
}