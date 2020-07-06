#ifndef COLORTOOLS_H
#define COLORTOOLS_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QColor>

class ColorTools: public QObject
{
    Q_OBJECT
public:
    static ColorTools* instanceAsJsExtention(QQmlEngine& engine, QObject *parent = nullptr, QQmlEngine::ObjectOwnership ownership = QQmlEngine::ObjectOwnership::JavaScriptOwnership)
    {
        ColorTools* ptr = new ColorTools(parent);
        auto object = engine.newQObject(ptr);
        engine.setObjectOwnership(ptr, ownership);
        engine.globalObject().setProperty("ColorTools", object);
        return ptr;
    }

    Q_INVOKABLE QColor toWB(const QColor& color);
    Q_INVOKABLE QColor adjustSaturation(const QColor& color, qreal factor); //factor must by in range of [-1.0 - +1.0], 0.0 - means no ajustment is made
    Q_INVOKABLE QColor adjustLightness(const QColor& color, qreal factor); //factor must by in range of [-1.0 - +1.0], 0.0 - means no ajustment is made
    Q_INVOKABLE QColor adjustHue(const QColor& color, qreal factor); //factor must by in range of [-1.0 - +1.0], 0.0 - means no ajustment is made

protected:
    ColorTools(QObject *parent = nullptr);

    QQmlEngine* getEngine() const;
};

#endif // COLORTOOLS_H
