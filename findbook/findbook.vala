
using Gtk;

//Creates a new VBox.
//Note:
//You can use Box with gtk_orientation_vertical instead, which is a quick and easy change. But the recommendation is to switch to Grid , since Box is going to go away eventually. See Migrating from other containers to GtkGrid.

int main(string[] args)
{
    Gtk.init (ref args);

    var window = new Gtk.Window ();

    window.title = "Find Book";
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (650, 650);
    window.destroy.connect (Gtk.main_quit);

//----------------------------------------
	var grid = new Gtk.Grid ();
	grid.column_spacing = 10;
	grid.row_spacing = 10;
	grid.margin = 15;	//Gtk.Widget属性

	var label = new Gtk.Label("输入要搜索的书名");
	//label.set_markup("<small></small>");
	grid.attach(label, 0, 0, 1, 1);

	var entry = new Gtk.Entry();
	entry.set_max_width_chars(40);
	entry.hexpand = true;
	grid.attach(entry, 1, 0, 1, 1);

	var button = new Gtk.Button.from_icon_name("system-search");
	grid.attach(button, 2, 0, 1, 1);

	var list = new Gtk.ListBox();
	list.insert(infogrid("/home/eexpss/1.jpg","凡·高密码","凡·高的举世名画《向日葵》里埋藏着怎样的秘密？"),-1);
	list.insert(infogrid("/home/eexpss/sample.png","凡·高密码","凡·高的举世名画《向日葵》里埋藏着怎样的秘密？"),-1);
	list.insert(infogrid("/home/eexpss/2.jpg","死亡密码","刑侦总队密码组是顶刑侦总队\n密码组是顶级情报人刑侦总队级情报人员的培训、任命和派遣机构"),-1);

	grid.attach(list, 0, 1, 3, 1);

//----------------------------------------
    window.add(grid);
    window.show_all();
    Gtk.main ();
    return 0;
}

Gtk.Grid infogrid(string imagefile, string bookname, string bookinfo)
{
	var g = new Gtk.Grid ();
	var img = new Gtk.Image.from_file(imagefile);
	var name = new Gtk.Label(bookname);
	name.halign = START;
	var info = new Gtk.TextView();
	info.buffer.text = bookinfo;
	info.expand = true;
	info.wrap_mode = CHAR;	//自动折行
	var pbar = new Gtk.ProgressBar();
	pbar.expand = true;
	var butt = new Gtk.Button.from_icon_name("emblem-downloads");

	g.margin = 10;	//Gtk.Widget属性
	g.column_spacing = 15;
	g.row_spacing = 15;
	g.attach(img,  0, 0, 1, 3);
	g.attach(name, 1, 0, 2, 1);
	g.attach(info, 1, 1, 2, 1);
	g.attach(pbar, 1, 2, 1, 1);
	g.attach(butt, 2, 2, 1, 1);

	return g;
}
