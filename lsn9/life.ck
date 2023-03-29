4 => int row_max;
4 => int col_max;
int life[row_max][col_max];
int life_new[row_max][col_max];

//[[0, 0, 0, 0], [0, 1, 0, 1], [1, 0, 0, 0], [1, 0, 1, 0]] @=> life;

fun int SetRndVol()
{
	return Std.rand2(0, 1); 
}

fun void Seed()
{
	for( 0 => int i; i < row_max ; i++ )
	{
		for( 0 => int j; j < col_max ; j++ )
		{
			SetRndVol() => life[i][j];
		}
	}
}

fun int is_live(int i, int j)
{
	return life[i][j];
}

fun void kill(int i, int j)
{
	0 => life_new[i][j];
}

fun void beget(int i, int j)
{
	1 => life_new[i][j];
}

fun void copy(int i, int j)
{
	life[i][j] => life_new[i][j];
}

fun int neighbor(int i, int j)
{
	0 => int count;
	
	for( (i-1) => int k; k <= (i+1) ; k++ )
	{
		for( (j-1) => int l; l <= (j+1) ; l++ )
		{
			//<<< "row = " + k + " | col = " + l + " | row_max = " + row_max >>>;
			if((k>=0) && (k<row_max) && (l>=0) && (l<col_max) && ((k!=i) || (l!=j)))
			{
				//<<< "inside" >>>;
				if(is_live(k, l)==1)
				{
					//<<< "value = " + life[k][l] >>>;
					count + 1 => count;
				}
			}
			
		}
	}
	return count;
}

fun void Change(int i, int j)
{
	if((is_live(i, j)==1) && neighbor(i, j)<2)
	{
		kill(i, j);
	}
	else if((is_live(i, j)==1) && neighbor(i, j)>3)
	{
		kill(i, j);
	}
	else if((is_live(i, j)==0) && neighbor(i, j)==3)
	{
		beget(i, j);
	}  
	else
	{
		copy(i, j);
	}
}

fun void LookUp()
{
	<<< "matrix" >>>;
	string sRow;
	for( 0 => int i; i < row_max ; i++ )
	{
		"" => sRow;
		for( 0 => int j; j < col_max ; j++ )
		{
			//<<< life[i][j] >>>;
			sRow + " | " + life[i][j] => sRow;
		}
		<<< sRow >>>;
	}
}

fun void ChangeAll()
{
	for( 0 => int i; i < row_max ; i++ )
	{
		for( 0 => int j; j < col_max ; j++ )
		{
			Change(i, j);
		}
	}
	life_new @=> life;
}

Seed();
LookUp();
0 => int generation;
while(true)
{
	//<<< "neighbor(2, 0)" >>>;
	//<<< neighbor(2, 0) >>>;
	ChangeAll();
	LookUp();
	<<< "generation = " + generation >>>;
	generation + 1 => generation;
	5000::ms => now;
}
