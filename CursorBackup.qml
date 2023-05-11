import QtQuick 2.0

Rectangle {
    id: container
    width: 100
    height: 100
    color: "transparent"

    // TODO: Delete this mouse area and replace with dwell time function
    // This mouse area does not allow you to click other things
//    MouseArea {
//        id: cursor_mouseArea
//        anchors.fill: parent
//        onPressAndHold: canvas.toggle()
//    }

    Canvas {
        id: canvas
        anchors.fill: parent

        property bool arrowFormState: false
        function toggle() { arrowFormState = !arrowFormState }

        property real angle: 0
        states: State {
            when: canvas.arrowFormState
            PropertyChanges { angle: Math.PI * 2; target: canvas }
        }
        transitions: Transition {
            NumberAnimation {
                property: "angle"
                easing.type: Easing.Linear
                duration: 1000
            }
        }

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
            ctx.fillStyle = 'rgba(255, 255, 255, .6)';
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
        // TODO: Change this so a dwell time triggers canvas.toggle()
        // TODO: Will then need to somehow interrupt the animation if the eyes move during animation
        Timer { interval: 1500; repeat: true; running: true; onTriggered: canvas.toggle() }
    }
}
