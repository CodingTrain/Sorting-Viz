class Dancer {
  PVector pos;
  float size;
  int value;
  int index;
  int max;
  float[] perlin;
  float perlinX, perlinY;
  color pantsColor = color(213, 184, 145);
  color skinColor = color(255, 213, 193);
  int animSelect = 0;
  boolean selected = false;
  boolean deselected = false;
  boolean pivot = false;
  boolean other = false;
  boolean compared = false;
  boolean swapped = false;
  boolean done = false;
  boolean addDelay = false;
  boolean idle = true;
  boolean end = false;
  int animMove = 0;
  float moveStep = 0;
  float forwardStep = 0;
  int wait = 0;
  float endScale = 0;
  
  Dancer(int s, int index, int max) {
    pos = new PVector(index, height / 2);
    size = 60 + 80 / max * s;
    value = s;
    this.index = index;
    this.max = max;
    perlin = new float[16];
    for (int i = 0; i < perlin.length; i++) {
      perlin[i] = random(100);
    }
    perlinX = random(100);
    perlinY = random(100);
  }
  
  boolean finished() {
    if (animSelect <= 0 && animMove <= 0 && wait <= 0) {
      return true;
    } else {
      return false;
    }
  }
  
  void select() {
    selected = false;
    animSelect = 6 * delay;
    forwardStep = 40.0 / animSelect;
  }
  void deselect() {
    selected = true;
    animSelect = 6 * delay;
    forwardStep = 40.0 / animSelect;
  }
  
  void compare() {
    wait = 30 * delay + 3;// - 1;
  }
  
  void moveTo(float newPos) {
    index = (int)newPos;
    wait = 10 * delay;
    animMove = 24 * delay;
    moveStep = (newPos - pos.x) / animMove;
  }
  
  void show() {
    float danceMagnifier = 10;
    if (wait > 0) {
      wait--;
      if (selected)
        danceMagnifier = 50;
      if (idle) {
        if (wait < 500 && wait > 300) {
          shout();
        }
      }
      if (wait == 0 && selected)
        compared = true;
    } else if (animSelect > 0) {
      animSelect--;
      danceMagnifier = 30;
      if (!selected) {
        pos.y += forwardStep;
      } else {
        pos.y -= forwardStep;
      }
      if (animSelect == 0) {
        compared = false;
        swapped = false;
        selected = !selected;
        if (!selected) {
          deselected = true;
          other = false;
          pivot = false;
          wait = 3 * delay;
        }
        if (done) {
          idle = true;
          if (addDelay)
            wait = 50 * delay;
        }
      }
    } else if (animMove > 0) {
      animMove--;
      pos.x += moveStep;
      danceMagnifier = 70;
      if (animMove == 0) {
        swapped = true;
        wait = 12 * delay;
      }
    } else if (selected) {
      danceMagnifier = 50;
    }
    
    float px = pos.x;
    float py = pos.y;
    
    if (end) {
      danceMagnifier = 70;
      perlinX += 0.01;
      perlinY += 0.01;
      px += (noise(perlinX) - 0.5) * endScale;
      py += (noise(perlinY) - 0.5) * endScale * 100;
      if (endScale < 1)
        endScale += 0.01;
    } else {
      perlinX += 0.01;
      perlinY += 0.01;
      px += (noise(perlinX) - 0.5) * (pos.y - height / 2) / 40;
      py += (noise(perlinY) - 0.5) * (pos.y - height / 2);
    }
    
    float w = width / (max * 3);
    float sw = w / 2;
    float centerX = (px + 0.5) * width / max;
    float centerY = py - size / 2;
    float leftX = centerX - w / 2;
    float rightX = centerX + w / 2;
    float bottomY = py;
    float topY = py - size;
    float leftBottomX = leftX + sw / 2;
    float leftBottomY = bottomY - sw / 2;
    float rightBottomX = rightX - sw / 2;
    float rightBottomY = bottomY - sw / 2;
    float leftShoulderX = leftX + sw / 3;
    float leftShoulderY = topY + sw / 2;
    float rightShoulderX = rightX - sw / 3;
    float rightShoulderY = topY + sw / 2;
    float headCenterX = centerX;
    float headCenterY = topY - w / 3;
    float headSize = w;
    
    // dynamic joints
    float[] dJoints = new float[] {
      leftX - w / 3,        // 0 - leftKneeX
      bottomY + w,          // 1 - leftKneeY
      rightX + w / 3,       // 2 - rightKneeX
      bottomY + w,          // 3 - rightKneeY
      leftX + sw / 4,       // 4 - leftFootX
      bottomY + w * 2,      // 5 - leftFootY
      rightX - sw / 4,      // 6 - rightFootX
      bottomY + w * 2,      // 7 - rightFootY
      leftX - w / 3,        // 8 - leftElbowX
      centerY - size / 4,   // 9 - leftElbowY
      rightX + w / 3,       // 10 - rightElbowX
      centerY - size / 4,   // 11 - rightElbowY
      leftX + sw / 3,       // 12 - leftHandX
      centerY,              // 13 - leftHandY
      rightX - sw / 3,      // 14 - rightHandX
      centerY               // 15 - rightHandY
    };
    
    if (!idle) {
      for (int i = 0; i < dJoints.length; i++) {
        perlin[i] += 0.1;
        dJoints[i] += (noise(perlin[i]) - 0.5) * danceMagnifier;
      }
    } else {
      // update some values for a nice idle stan
      dJoints[0] = leftX;
      dJoints[2] = rightX;
      dJoints[8] = leftX - w / 8;
      dJoints[9] = centerY - size / 8;
      dJoints[10] = rightX + w / 8;
      dJoints[11] = centerY - size / 8;
      dJoints[13] = centerY + size / 6;
      dJoints[15] = centerY + size / 6;
    }
    
    // draw body
    fill(0);
    noStroke();
    rect(centerX, centerY, w, size, 10);
    
    // draw number
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text(value, centerX, centerY);
    
    // draw underwear
    fill(pantsColor);
    noStroke();
    rect(centerX, bottomY - sw / 2, w, sw, 10);
    
    // draw upper legs
    stroke(pantsColor);
    strokeWeight(sw);
    line(leftBottomX, leftBottomY, dJoints[0], dJoints[1]);
    line(rightBottomX, rightBottomY, dJoints[2], dJoints[3]);
    
    // draw boots
    stroke(0);
    line(dJoints[0], dJoints[1], dJoints[4], dJoints[5]);
    line(dJoints[2], dJoints[3], dJoints[6], dJoints[7]);
    
    // draw upper arms
    stroke(255);
    strokeWeight(sw * 0.75);
    line(leftShoulderX, leftShoulderY, dJoints[8], dJoints[9]);
    line(rightShoulderX, rightShoulderY, dJoints[10], dJoints[11]);
    
    // draw lower arms
    line(dJoints[8], dJoints[9], dJoints[12], dJoints[13]);
    line(dJoints[10], dJoints[11], dJoints[14], dJoints[15]);
    
    // draw hands
    stroke(skinColor);
    point(dJoints[12], dJoints[13]);
    point(dJoints[14], dJoints[15]);
    
    // draw head
    noStroke();
    fill(skinColor);
    ellipse(headCenterX, headCenterY, headSize, headSize);
    
    // draw face
    stroke(0);
    if (idle) {
      strokeWeight(sw / 10);
      float leftEyeLeft = headCenterX - headSize / 4;
      float leftEyeRight = headCenterX - headSize / 8;
      float rightEyeLeft = headCenterX + headSize / 8;
      float rightEyeRight = headCenterX + headSize / 4;
      float eyeY = headCenterY - headSize / 6;
      float mouthL = headCenterX - headSize / 10;
      float mouthR = headCenterX + headSize / 10;
      float mouthY = headCenterY + headSize / 6;
      curve(leftEyeLeft - sw, eyeY - sw / 2, leftEyeLeft, eyeY, leftEyeRight, eyeY, leftEyeRight + sw, eyeY - sw / 2);
      curve(rightEyeLeft - sw, eyeY - sw / 2, rightEyeLeft, eyeY, rightEyeRight, eyeY, rightEyeRight + sw, eyeY - sw / 2);
      curve(mouthL - sw, mouthY - sw / 2, mouthL, mouthY, mouthR, mouthY, mouthR + sw, mouthY - sw / 2);
    } else if (danceMagnifier <= 10) {
      float eyeL = headCenterX - headSize / 6;
      float eyeR = headCenterX + headSize / 6;
      float eyeY = headCenterY - headSize / 6;
      float mouthL = headCenterX - headSize / 7;
      float mouthR = headCenterX + headSize / 7;
      float mouthY = headCenterY + headSize / 6;
      strokeWeight(sw / 4);
      point(eyeL, eyeY);
      point(eyeR, eyeY);
      strokeWeight(sw / 10);
      curve(mouthL - sw, mouthY - sw / 2, mouthL, mouthY, mouthR, mouthY, mouthR + sw, mouthY - sw / 2);
    } else if (danceMagnifier <= 30) {
      float eyeL = headCenterX - headSize / 6;
      float eyeR = headCenterX + headSize / 6;
      float eyeY = headCenterY - headSize / 6;
      float mouthL = headCenterX - headSize / 6;
      float mouthR = headCenterX + headSize / 6;
      float mouthY = headCenterY + headSize / 7;
      strokeWeight(sw / 4);
      point(eyeL, eyeY);
      point(eyeR, eyeY);
      strokeWeight(sw / 10);
      curve(mouthL, mouthY - sw * 2, mouthL, mouthY, mouthR, mouthY, mouthR, mouthY - sw * 2);
    } else if (danceMagnifier <= 50) {
      float eyeL = headCenterX - headSize / 6;
      float eyeR = headCenterX + headSize / 6;
      float eyeY = headCenterY - headSize / 6;
      float mouthL = headCenterX - headSize / 5;
      float mouthR = headCenterX + headSize / 5;
      float mouthY = headCenterY + headSize / 8;
      strokeWeight(sw / 3);
      point(eyeL, eyeY);
      point(eyeR, eyeY);
      strokeWeight(sw / 10);
      curve(mouthL, mouthY - sw * 2, mouthL, mouthY, mouthR, mouthY, mouthR, mouthY - sw * 2);
      line(mouthL, mouthY, mouthR, mouthY);
    } else {
      float eyeL = headCenterX - headSize / 6;
      float eyeR = headCenterX + headSize / 6;
      float eyeY = headCenterY - headSize / 6;
      float mouthL = headCenterX - headSize / 4;
      float mouthR = headCenterX + headSize / 4;
      float mouthY = headCenterY + headSize / 10;
      strokeWeight(sw / 2);
      point(eyeL, eyeY);
      point(eyeR, eyeY);
      strokeWeight(sw / 10);
      curve(mouthL, mouthY - sw * 4, mouthL, mouthY, mouthR, mouthY, mouthR, mouthY - sw * 4);
      line(mouthL, mouthY, mouthR, mouthY);
    }
    
    float hatY = headCenterY - headSize * 2 / 3;
    // draw selected
    if (pivot) {
      stroke(0);
      strokeWeight(headSize);
      point(centerX, height - headSize);
      // draw hat
      noStroke();
      fill(0);
      rect(centerX, hatY, headSize * 0.8, headSize / 2, headSize / 8);
      rect(centerX, hatY + headSize / 4, headSize * 1.5, headSize / 8);
    }
    if (other) {
      stroke(255, 0, 0);
      strokeWeight(headSize);
      point(centerX, height - 3 * headSize);
      if (pivot) {
        hatY -= headSize / 2;
      }
      // draw hat
      noStroke();
      fill(255, 0, 0);
      rect(centerX, hatY, headSize * 0.8, headSize / 2, headSize / 8);
      rect(centerX, hatY + headSize / 4, headSize * 1.5, headSize / 8);
    }
  }
  
  void shout() {
    fill(255);
    textSize(40);
    text("Oszd meg és uralkodj!", width / 2, height - 120);
    fill(150);
    textSize(20);
    text("(Divide and conquer!)", width / 2, height - 80);
  }
}
