#ifndef REVIEW_HXX
#define REVIEW_HXX

#include <QObject>
#include <QList>
#include <QQueue>
#include <QVector>
#include <QVariant>
#include "abstractinfomation.hxx"
#include <QtGlobal>
#include <QtMath>
struct Weight {
    QVariant data_;
    int last_index_;
    int count_;
    int will_index_;
    Weight():last_index_(0),count_(0),will_index_(0){willCompute();}
    void willCompute(){
        will_index_ = last_index_ + qRound(qPow(2, count_));
    }
};
struct Record {
    QVariant data_;
};

class HowToReview
{
public:
    typedef AbstractInfomation* AI;
    virtual AI next() = 0;
    virtual void save(AI,int) = 0;
protected:
    QQueue<AbstractInfomation* > reviewList_;
    QList<Record> reviewRecord_;
};
class AB : public HowToReview
{
    AI next(){}
    void save(AI,int){}
};
// latest longer unused
class Review : public QObject
{
    Q_OBJECT
public:
    explicit Review(QObject *parent = 0);
    ~Review();

    void startReview();
    void pauseReview();
    void stopReview();

    void setReviewInfomation(const QList<AbstractInfomation*>&);
    void addReviewInfomation(AbstractInfomation*);

    void enQueue();
    void deQueue();
    void head();

private:
//    QQueue<AbstractInfomation* > reviewList_;
//    QMap<int , AbstractInfomation* > reviewWeight_;
    HowToReview* howToReview_;
    QVector<Weight> testList_;
    int lastPush_;
signals:

public slots:
    void test();
    void push(QVariant v);
    void next();
    void show(Weight obj);
};

#endif // REVIEW_HXX
