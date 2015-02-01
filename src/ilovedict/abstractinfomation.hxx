#ifndef ABSTRACTINFOMATION_HXX
#define ABSTRACTINFOMATION_HXX

#include <QObject>
struct Object {
    std::string word;
    bool operator <(const Object &b) const
    {
        return this->word < b.word;
    }
};
class AbstractInfomation : public QObject
{
    Q_OBJECT
public:
    explicit AbstractInfomation(QObject *parent = 0);
    ~AbstractInfomation();

signals:

public slots:
};

#endif // ABSTRACTINFOMATION_HXX
