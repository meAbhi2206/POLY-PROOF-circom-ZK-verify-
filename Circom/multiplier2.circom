pragma circom 2.0.0;

template AND() {
  signal input A;
  signal input B;
  signal output X;

  X <== A*B;
}

template NOT() {
  signal input B;
  signal output Y;

  Y <== 1 + B - 2*B;
}

template OR() {
  signal input X;
  signal input Y;
  signal output Q;

  Q <== X + Y - X*Y;
}

component main = OR();

