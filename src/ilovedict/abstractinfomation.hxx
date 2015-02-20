#ifndef ABSTRACTINFOMATION_HXX
#define ABSTRACTINFOMATION_HXX

#include <QObject>
#include <QList>
//struct Object {
//    std::string word;
//    bool operator <(const Object &b) const
//    {
//        return this->word < b.word;
//    }
//};
class AbstractInfomation : public QObject
{
    Q_OBJECT
public:
    explicit AbstractInfomation(QObject *parent = 0);
    ~AbstractInfomation();
    virtual void parse(const QString& content) = 0;
    virtual QString save() = 0;

private:

signals:

public slots:
};
class AnkiObject : public QObject
{
    Q_OBJECT
public:
    explicit AnkiObject(QObject *parent = 0);
    ~AnkiObject();


private:

signals:

public slots:
};
class TextAnkiObject : public AnkiObject
{
    Q_OBJECT
public:
    explicit TextAnkiObject(QObject *parent = 0);
    ~TextAnkiObject();
    QString front() const { return front_;}
    QString back() const { return back_;}
    QString detail() const { return detail_;}
private:
    QString front_;
    QString back_;
    QString detail_;

signals:

public slots:
};

class AnkiInfomation : public AbstractInfomation
{
    Q_OBJECT
public:
    explicit AnkiInfomation(QObject *parent = 0);
    ~AnkiInfomation();
    void parse(const QString& content);
    QString save();

private:
    AnkiObject* ankiObject_;

signals:

public slots:
};

#endif // ABSTRACTINFOMATION_HXX
