#include "review.hxx"
#include <assert.h>
#include <QDebug>
Review::Review(QObject *parent) : QObject(parent)
{

}

Review::~Review()
{

}

void Review::test()
{
    int last_temp = 10;
    push(int(1));
    push(int(2));
    while(true) {
        next();
        int count = 0;
        for (int i = 0; i < testList_.size(); ++i) {
            Weight& obj = testList_[i];
            int temp = obj.data_.toInt();
            if (obj.count_ >= 5 && temp >= last_temp) {
                qDebug() << last_temp<<testList_.size();
                last_temp++;

                count = obj.count_;
                break;
            }
        }
//        if (count >= 5) {
//            qDebug() << testList_.size();
//            break;
//        }
    }


}

void Review::push(QVariant v)
{
    lastPush_ = v.toInt();
    Weight obj;
    obj.data_ = v;
    obj.last_index_ = testList_.size();
    obj.count_ = 1;
    obj.willCompute();
    testList_.append(obj);
}

void Review::next()
{
    int min_index = 65536;
    int will_index = 65535;
    for (int i = 0; i < testList_.size(); ++i) {
        Weight& obj = testList_[i];
        obj.willCompute();
        int will = obj.will_index_;
        if (will < will_index) {
            will_index = will;
            min_index = i;
        }
    }

    assert (min_index < 65535);
    assert (will_index < 65535);

    if (will_index <= testList_.size()) {
        Weight& obj = testList_[min_index];
        obj.count_++;
        obj.last_index_ = testList_.size();
        obj.willCompute();
        testList_.append(obj);
        for (int i = 0; i < testList_.size(); ++i) {
            if (testList_[i].data_ == obj.data_) {
                testList_[i] = obj;
            }
        }

    } else {
        push(int(lastPush_+1));
    }

}

void Review::show(Weight obj)
{

}

