#include <QCoreApplication>
#include <map>
#include <list>
#include <vector>
#include <iostream>
#include <set>
#include <fstream>
#include <string>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include "review.hxx"
/*
>>>>>>> 009df782699bef02f1a12b0065852707f44e5e65
struct Object {
    std::string word;
    bool operator <(const Object &b) const
    {
        return this->word < b.word;
    }
};

Object next_char(const std::vector<Object>& list) {
    std::map<Object, std::pair<int,int> > map;
    for (int i = 0; i < list.size(); ++i) {
        Object ch = list.at(i);
        std::map<Object, std::pair<int,int> >::iterator it = map.find(ch);
        if (it != map.end()) {
            it->second.first++;
            it->second.second = i;
        } else {
            map.insert(std::make_pair(ch, std::make_pair(1,i)));
        }
    }

    std::map <Object,int> weightMap;
    std::map<Object, std::pair<int,int> >::iterator mit = map.begin();
    std::map<Object, std::pair<int,int> >::iterator mend = map.end();
    for (; mit != mend; ++mit) {
        int value = 2 * (mit->second.first) + mit->second.second;
        weightMap.insert(std::make_pair(mit->first, value));
    }
    std::map<Object,int>::iterator wit = weightMap.begin();
    std::map<Object,int>::iterator wend = weightMap.end();
    int minValue = wit->second;
    Object minChar = {" "};
    for (; wit != wend; ++wit) {
        if (wit->second < minValue) {
            minValue = wit->second;
            minChar = wit->first;
        }
    }
    if (minValue > list.size()) {
        return {" "};
    }
    std::map<Object,int > sameValueMap;
    for (wit = weightMap.begin(); wit != wend; ++wit) {
        if (wit->second == minValue) {
            std::map<Object, std::pair<int,int> >::iterator it = map.find(wit->first);
            if (it != map.end()) {
                sameValueMap.insert(std::make_pair(wit->first, it->second.second));
            }
        }
    }

    int minIndex = 0;
    Object minFinalChar  = {" "};
    std::map<Object,int >::iterator sit = sameValueMap.begin();
    std::map<Object,int >::iterator send= sameValueMap.begin();
    minIndex = sit->second;
    minFinalChar = sit->first;
    for (; sit != send; ++sit) {
        if (sit->second < minIndex) {
            minIndex = sit->second;
            minFinalChar = sit->first;
        }
    }

    return minFinalChar;

}
std::list<Object> initData()
{
    std::list<Object> list;

    std::ifstream file("/Users/jiyuhang/words.txt");
//    file.open("~/words.txt");
    if (file.is_open()) {
        std::string word;
        while ( getline (file,word) )
        {
            Object obj;
            obj.word = word;
            list.push_back(obj);
        }
        file.close();

    }

    return list;
}
void parseResult()
{
    std::list<Object> list;
    std::map<std::string, std::vector<int> > wordIndexs;

    std::ifstream file("/Users/jiyuhang/result.txt");
    if (file.is_open()) {
        std::string line;
        while ( getline (file,line) )
        {
            std::stringstream ss(line);
            std::string word;
            int index;
            ss >> index >> word;
            std::map<std::string, std::vector<int> >::iterator it = wordIndexs.find(word);
            if (it != wordIndexs.end()) {
                it->second.push_back(index);
            } else {
                std::vector<int> indexVector;
                indexVector.push_back(index);
                wordIndexs.insert(std::make_pair(word, indexVector));
            }

        }
        file.close();
   }
   std::multimap<int,std::vector<int> > orderVector;
   std::map<std::string, std::vector<int> >::iterator it = wordIndexs.begin();
   std::map<std::string, std::vector<int> >::iterator ie = wordIndexs.end();
   for (;it!=ie;++it) {
       std::vector<int>& indexs = it->second;
//       std::cout<<it->first<<"\t";
       std::vector<int> minus;
       int min = indexs.at(0);

       for(int i = 0; i < indexs.size(); ++i) {
           if (i == 0) {
               min = indexs.at(0);
//               std::cout<<indexs.at(0)<<"\t";
               continue;
           }
//           std::cout<< indexs.at(i) - min <<"\t";
           minus.push_back(indexs.at(i) - min);
           min = indexs.at(i);
       }
//       std::cout<<std::endl;
       for (int i = 0; i < minus.size();++i){
           std::cout<<minus.at(i)<<"\t";
       }
       std::cout<<std::endl;
       orderVector.insert(std::make_pair(indexs.at(0),minus));

   }
   std::multimap<int,std::vector<int> >::iterator oit =  orderVector.begin();
   std::multimap<int,std::vector<int> >::iterator oie =  orderVector.end();
   int maxCol = 0;
   int minCol = 1000000;
   double avgCol = 0;
   for (;oit!=oie;++oit) {
       std::vector<int>& v = oie->second;

       int len = v.size();
//       std::cout<<v.at(0)<<"\t"<<len<<std::endl;

       if (maxCol < len) maxCol = len;
       if (minCol > len) minCol = len;
       avgCol += len;

       for (int i = 0; i < v.size();++i){
//           std::cout<<v.at(i)<<"\t";
       }
//       std::cout<<std::endl;
   }

//   std::cout<< "max col = " <<maxCol<<std::endl;
//   std::cout<< "min col = " <<minCol<<std::endl;
//   std::cout<< "avg col = " <<avgCol / orderVector.size()<<std::endl;

   exit(0);
}
*/
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    Review review;
    review.test();
/*
    char alpha[26] = {'a','b','c','d','e','f','g',
        'h','i','j','k','l','m','n',
        'o','p','q','r','s','t',
        'u','v','w','x','y','z'};
    parseResult();
    std::list<Object> alphabeta = initData();
    if (alphabeta.empty()) return 0;
    //    for (int i = 2; i < 26; ++i)
    //        alphabeta.push_back(alpha[i]);


    //    std::cout <<"alphabeta's size = "<< alphabeta.size()<<std::endl;
    //    for(auto ch: alphabeta) {
    //        std::cout << ch;
    //    }
    //    std::cout <<std::endl;
    //    for (int i = 0; i < alphabeta.size(); ++i) {
    //        std::list<char>::iterator it = alphabeta.begin();
    //        for (int j = i; j>0; j--) {
    //            it++;
    //        }
    //        char ch = *(it);
    //        std::cout<< ch;
    //    }

    std::vector<Object> mainList;
    Object first = alphabeta.front();
    alphabeta.pop_front();
    mainList.push_back(first);
    //    for (int i = 0; i < 5; ++i) {
    //        char ch = mainList[i];
    //        std::cout <<i<<"\t"<< ch <<std::endl;
    //    }


    for (int i = 0; i < 10000; ++i) {
        Object ch = next_char(mainList);
        if (ch.word == " " || ch.word.empty()) {
            if (alphabeta.empty()) {
                for (int i = 0; i < mainList.size(); ++i) {
                    std::cout <<i<<"\t"<< mainList.at(i).word<<std::endl;
                }
                return 0;
            }
            alphabeta.pop_front();
            Object next = alphabeta.front();
            mainList.push_back(next);
            //            std::cout <<i+5<<"\t"<< next <<std::endl;

        } else {
            mainList.push_back(ch);
            //            std::cout <<i+5<<"\t"<< ch <<std::endl;
        }
    }
    //    for (auto ch : mainList) {
    //        std::cout << ch;
    //    }
    //    std::cout << mainList.size()<< std::endl;
    for (int i = 0; i < mainList.size(); ++i) {
        std::cout <<i<<"\t"<< mainList.at(i).word<<std::endl;
    }


*/
        return a.exec();
    return 0;
}
