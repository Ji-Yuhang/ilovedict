#ifndef REVIEW_HXX
#define REVIEW_HXX

#include <QObject>

class Review : public QObject
{
    Q_OBJECT
public:
    explicit Review(QObject *parent = 0);
    ~Review();

signals:

public slots:
};

#endif // REVIEW_HXX
