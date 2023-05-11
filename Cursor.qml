import QtQuick 2.0

Rectangle {
    id: container

    property real angle: 0

    width: 100
    height: 100
    color: "transparent"

    Canvas {
        id: canvas
        anchors.fill: parent

        property real angle: container.angle

        onAngleChanged: requestPaint()

        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centerX = Math.round(container.width / 2);
            var centerY = Math.round(container.height / 2);
            var radius = Math.round(container.width / 8);


            // Draw Swipe for Dwell Time Animation
            ctx.beginPath();
            ctx.fillStyle = 'rgba(255, 255, 255, .5)';
            ctx.moveTo(centerX, centerY);
            ctx.arc(centerX, centerY, radius, 0, angle, false);
            ctx.lineTo(centerX, centerY);
            ctx.fill();

            // Draw Exterior Circle
            ctx.strokeStyle = 'rgb(255, 255, 255)';
            ctx.lineWidth = 2;
            ctx.beginPath();

            // Bottom Right Arc
            ctx.moveTo(centerX + radius, centerY)
            ctx.arcTo(centerX + radius, centerY + radius, centerX, centerY + radius, radius)

            // Bottom Left Arc
            ctx.moveTo(centerX, centerY + radius)
            ctx.arcTo(centerX - radius, centerY + radius, centerX - radius, centerY, radius)

            // Top Left Arc
            ctx.moveTo(centerX - radius, centerY)
            ctx.arcTo(centerX - radius, centerY - radius, centerX, centerY - radius, radius)

            // Top Right Arc
            ctx.moveTo(centerX, centerY - radius)
            ctx.arcTo(centerX + radius, centerY - radius, centerX + radius, centerY, radius)

            ctx.stroke();

            // Draw Interior point
            ctx.beginPath();
            ctx.fillStyle = 'rgb(255, 255, 255)';
            ctx.moveTo(centerX, centerY);
            ctx.arc(centerX, centerY, Math.round(radius / 10), 0, Math.PI * 2, false);
            ctx.fill();
        }
    }
}
