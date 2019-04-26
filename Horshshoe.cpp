#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;

int main()
{
    vector<int> a;
    int n=4;
    for(int i=0;i<4;i++){
        int x;
        cin>>x;
        if(find(a.begin(),a.end(),x)!=a.end()){
            
            a.push_back(x);
        }
        else{
        	n--;
            a.push_back(x);
        }
    }
    cout<<n<<endl;

    return 0;
}
