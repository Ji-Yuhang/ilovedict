#include "abstractinfomation.hxx"

AbstractInfomation::AbstractInfomation(QObject *parent) : QObject(parent)
{

}

AbstractInfomation::~AbstractInfomation()
{

}



AnkiInfomation::AnkiInfomation(QObject *parent)
{

}

AnkiInfomation::~AnkiInfomation()
{

}

void AnkiInfomation::parse(const QString &content)
{

}

QString AnkiInfomation::save()
{
    QString content;
    return content;
}


AnkiObject::AnkiObject(QObject *parent)
{

}

AnkiObject::~AnkiObject()
{

}


TextAnkiObject::TextAnkiObject(QObject *parent)
{

}

TextAnkiObject::~TextAnkiObject()
{

}
