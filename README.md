//把UISearchBar和UISearchDisplayController封装在一起的一个Search控件，用时只需在需要调用的ViewController里调用即可。完美适配tableView。
//A customed and packaged category that combined UISearchBar and UISearchDisplayController , you can use it in your ViewController with only a few steps and it's fits good in tableView.



//step 1
# RoySearch.h
//step 2
@property (nonatomic,strong) RoySearch *mySearch;
//setp 3
  self.mySearch = [[RoySearch alloc]initWithViewController:self];
  self.tableView.tableHeaderView = self.mySearch.searchBar;

