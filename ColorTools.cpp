#include "ColorTools.h"
#include <QtQml>
#include <QQmlContext>

QQmlEngine* ColorTools::getEngine() const
{
    QQmlEngine* engine = qmlEngine(this);
    if(engine == nullptr)
       engine = dynamic_cast<QQmlEngine*>(qjsEngine(this));

    return engine;
}

ColorTools::ColorTools(QObject *parent):
    QObject(parent)
{}

QColor ColorTools::toWB(const QColor& color)
{
    QColor hsl = color.toHsl();
    return QColor::fromHsl(hsl.hslHue(), 0, hsl.lightness(), hsl.alpha());
}

QColor ColorTools::adjustSaturation(const QColor& color, qreal factor)
{
    QColor hsl = color.toHsl();

    if(factor > 1.0)
        factor = 1.0;
    else if(factor < -1.0)
        factor = -1.0;

    qreal ds = (factor >= 0.0) ? 1.0 - hsl.hslSaturationF() : hsl.hslSaturationF();

    qreal s = hsl.hslSaturationF() + ds * factor;
    const auto& result = QColor::fromHslF(hsl.hslHueF(), s, hsl.lightnessF(), hsl.alphaF());
    return result;
}

QColor ColorTools::adjustLightness(const QColor& color, qreal factor)
{
    QColor hsl = color.toHsl();

    if(factor > 1.0)
        factor = 1.0;
    else if(factor < -1.0)
        factor = -1.0;

    qreal dl = (factor >= 0.0) ? 1.0 - hsl.lightnessF() : hsl.lightnessF();
    qreal l = hsl.lightnessF() + dl * factor;
    hsl.setHslF(hsl.hslHueF(), hsl.hslSaturationF(), l, hsl.alphaF());
    const auto& result = hsl.toRgb();
    return result;
}

QColor ColorTools::adjustHue(const QColor& color, qreal factor)
{
    QColor hsl = color.toHsl();
    const int dHueMax = 360;

    int hf = hsl.hslHue();
    if(hf < 0) hf = 0;

    int dh = int(round(dHueMax * factor));
    dh %= dHueMax;
    int h = (hf + dh) % dHueMax;
    h = (h >= 0) ? h : dHueMax + h;

    const auto& result = QColor::fromHsl(h, hsl.hslSaturation(), hsl.lightness(), hsl.alpha());
    return result;
}
