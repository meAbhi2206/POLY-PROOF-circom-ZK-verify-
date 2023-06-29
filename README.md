# Project Title

Logical Gate Circom Circuit with ZK-SNARK Proof

## Description

This project implements a logical gate circuit using the circom programming language. The circuit implements the following truth table:

```
A B X Y Q
0 0 0 1 1
0 1 0 0 0
1 0 0 1 1
1 1 1 0 1
```

The goal of the project is to prove that you know the inputs A=0 and B=1 that yield a 0 output. 

The project includes the following steps:

1. Write a correct  .circom implementation that represents the logical gate.
2. Compile the circuit using circom to generate circuit intermediaries.
3. Generate a proof using the inputs A=0 and B=1.
4. Deploy a solidity verifier contract.
5. Call the `verifyProof()` method on the verifier contract and assert that the output is true.

## Getting Started

### Installing

To get started with the project, follow these steps:

1. clone the circom repository :
    `git clone https://github.com/iden3/circom.git`
   
2. Install the required dependencies :
   `cargo build --release`
   `cargo install --path circom`
   
3. Installing snarkjs :
   `npm install -g snarkjs`

### Executing program

To run the project, follow these steps:

1. Navigate to the project directory: `cd project-directory`
2. write `multiplier2.circom` file to implement the logical gate circuit. 
3. Compile the circuit to generate circuit intermediaries:

    ```
   circom multiplier2.circom --r1cs --wasm --sym --c --json
   ```  
5. Create a file named input.json containing the inputs written in the standard json format. 

   ```
    {"A": 0, "B": 1}
    ```
  
7. Compute the Witness : 
   Enter in the directory `multiplier2_js`, add the the file `input.json` and execute:

    ```
   node generate_witness.js multiplier2.wasm input.json witness.wtns
   ```
9. We are going to use the Groth16 zk-SNARK protocol.
10. Groth16 requires a per circuit trusted setup. In more detail, the trusted setup consists of 2 parts:
  * The powers of tau, which is independent of the circuit.
  * The phase 2, which depends on the circuit.
    
9. we generate a .zkey file that will contain the proving and verification keys together.
 
  ```
  snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
  ```

10. Export the verification key:
 
  ```
  snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json
  ```

11. Generating a Proof:

    ```
    snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
    ```

13. Verifying a Proof

    ```
    snarkjs groth16 verify verification_key.json public.json proof.json
    ```

15. Verifying from a Smart Contract:
* Generate the Solidity code (`Verifier.sol`) using the command:

  ```
  snarkjs zkey export solidityverifier multiplier2_0001.zkey verifier.sol
  ```

* You can take the code from the file `verifier.sol` and cut and paste it in Remix.
* Compile the contract.
* Click on the "Deploy & Run Transactions" tab in the Remix editor. From the "Environment" dropdown, select the desired development environment (Injected Web3).
* The Verifier has a view function called verifyProof that returns TRUE if and only if the proof and the inputs are valid. To facilitate the call, you can use snarkJS to generate the parameters of the call by typing:

    ```
    snarkjs generatecall
    ```

* The input would look like this

     ```
    ["0x2670d22faa96fe641ec0c17f7a47d8195eae1e7755c5eb26820029e1fcf247e5", "0x17a112810df8cd07c321b7acbbdb6c94d09bb631de48a89bbef3f0e0edf8035c"],[["0x11d7467c664c9f57f70c3311a212a3d57764760be697f9c794bcc7ecf097c90b", "0x15d4ef6e68f2cfd0c2d4466b87d51c2de2d4bdf092ba6bdbe711fff6b678391f"],["0x1d1f22553a061457a9f39fd5be3cb95f09d1494d0bae5ff67af02d0f585e57e2", "0x2602bc56d0e7d3b05e58c6df4d98853a84ae396351a75d42ea335613574f4e22"]],["0x0a8586343d884a447e8227fa4f52b6e34e0a82dcee2cca37f2f3662530d5aa4f", "0x0308d58c5920d3f2e16bebb314d0c75ca95c1cd790eafe00cef7e9087e0385e0"],["0x0000000000000000000000000000000000000000000000000000000000000021"]
    ```

* Copy and paste this to the parameters field of the `verifyProof()` method in Remix.
* This method should return `TRUE`.


## Author 

Abhishek Ranjan

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
