['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.11;\n', '\n', 'contract ProxyFactory {\n', '    /// @dev See comment below for explanation of the proxy INIT_CODE\n', '    bytes private constant INIT_CODE =\n', "        hex'604080600a3d393df3fe'\n", "        hex'7300000000000000000000000000000000000000003d36602557'\n", "        hex'3d3d3d3d34865af1603156'\n", "        hex'5b363d3d373d3d363d855af4'\n", "        hex'5b3d82803e603c573d81fd5b3d81f3';\n", '    /// @dev The main address that the deployed proxies will forward to.\n', '    address payable public immutable mainAddress;\n', '\n', '    constructor(address payable addr) public {\n', "        require(addr != address(0), '0x0 is an invalid address');\n", '        mainAddress = addr;\n', '    }\n', '\n', '    /**\n', '     * @dev This deploys an extremely minimalist proxy contract with the\n', '     * mainAddress embedded within.\n', '     * Note: The bytecode is explained in comments below this contract.\n', '     * @return dst The new contract address.\n', '     */\n', '    function deployNewInstance(bytes32 salt) external returns (address dst) {\n', '        // copy init code into memory\n', '        // and immutable ExchangeDeposit address onto stack\n', '        bytes memory initCodeMem = INIT_CODE;\n', '        address payable addrStack = mainAddress;\n', '        assembly {\n', '            // Get the position of the start of init code\n', '            let pos := add(initCodeMem, 0x20)\n', '            // grab the first 32 bytes\n', '            let first32 := mload(pos)\n', '            // shift the address bytes 8 bits left\n', '            let addrBytesShifted := shl(8, addrStack)\n', '            // bitwise OR them and add the address into the init code memory\n', '            mstore(pos, or(first32, addrBytesShifted))\n', '            // create the contract\n', '            dst := create2(\n', '                0, // Send no value to the contract\n', '                pos, // Deploy code starts at pos\n', '                74, // Deploy + runtime code is 74 bytes\n', '                salt // 32 byte salt\n', '            )\n', '            // revert if failed\n', '            if eq(dst, 0) {\n', '                revert(0, 0)\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '/*\n', '    // PROXY CONTRACT EXPLANATION\n', '\n', '    // DEPLOY CODE (will not be returned by web3.eth.getCode())\n', '    // STORE CONTRACT CODE IN MEMORY, THEN RETURN IT\n', '    POS | OPCODE |  OPCODE TEXT      |  STACK                               |\n', '    00  |  6040  |  PUSH1 0x40       |  0x40                                |\n', '    02  |  80    |  DUP1             |  0x40 0x40                           |\n', '    03  |  600a  |  PUSH1 0x0a       |  0x0a 0x40 0x40                      |\n', '    05  |  3d    |  RETURNDATASIZE   |  0x0 0x0a 0x40 0x40                  |\n', '    06  |  39    |  CODECOPY         |  0x40                                |\n', '    07  |  3d    |  RETURNDATASIZE   |  0x0 0x40                            |\n', '    08  |  f3    |  RETURN           |                                      |\n', '\n', '    09  |  fe    |  INVALID          |                                      |\n', '\n', '    // START CONTRACT CODE\n', '\n', '    // Push the ExchangeDeposit address on the stack for DUPing later\n', '    // Also pushing a 0x0 for DUPing later. (saves runtime AND deploy gas)\n', '    // Then use the calldata size as the decider for whether to jump or not\n', '    POS | OPCODE |  OPCODE TEXT      |  STACK                               |\n', '    00  |  73... |  PUSH20 ...       |  {ADDR}                              |\n', '    15  |  3d    |  RETURNDATASIZE   |  0x0 {ADDR}                          |\n', '    16  |  36    |  CALLDATASIZE     |  CDS 0x0 {ADDR}                      |\n', '    17  |  6025  |  PUSH1 0x25       |  0x25 CDS 0x0 {ADDR}                 |\n', '    19  |  57    |  JUMPI            |  0x0 {ADDR}                          |\n', '\n', '    // If msg.data length === 0, CALL into address\n', '    // This way, the proxy contract address becomes msg.sender and we can use\n', '    // msg.sender in the Deposit Event\n', '    // This also gives us access to our ExchangeDeposit storage (for forwarding address)\n', '    POS | OPCODE |  OPCODE TEXT      |  STACK                                       |\n', '    1A  |  3d    |  RETURNDATASIZE   |  0x0 0x0 {ADDR}                              |\n', '    1B  |  3d    |  RETURNDATASIZE   |  0x0 0x0 0x0 {ADDR}                          |\n', '    1C  |  3d    |  RETURNDATASIZE   |  0x0 0x0 0x0 0x0 {ADDR}                      |\n', '    1D  |  3d    |  RETURNDATASIZE   |  0x0 0x0 0x0 0x0 0x0 {ADDR}                  |\n', '    1E  |  34    |  CALLVALUE        |  VALUE 0x0 0x0 0x0 0x0 0x0 {ADDR}            |\n', '    1F  |  86    |  DUP7             |  {ADDR} VALUE 0x0 0x0 0x0 0x0 0x0 {ADDR}     |\n', '    20  |  5a    |  GAS              |  GAS {ADDR} VALUE 0x0 0x0 0x0 0x0 0x0 {ADDR} |\n', '    21  |  f1    |  CALL             |  {RES} 0x0 {ADDR}                            |\n', '    22  |  6031  |  PUSH1 0x31       |  0x31 {RES} 0x0 {ADDR}                       |\n', '    24  |  56    |  JUMP             |  {RES} 0x0 {ADDR}                            |\n', '\n', '    // If msg.data length > 0, DELEGATECALL into address\n', '    // This will allow us to call gatherErc20 using the context of the proxy\n', '    // address itself.\n', '    POS | OPCODE |  OPCODE TEXT      |  STACK                                 |\n', '    25  |  5b    |  JUMPDEST         |  0x0 {ADDR}                            |\n', '    26  |  36    |  CALLDATASIZE     |  CDS 0x0 {ADDR}                        |\n', '    27  |  3d    |  RETURNDATASIZE   |  0x0 CDS 0x0 {ADDR}                    |\n', '    28  |  3d    |  RETURNDATASIZE   |  0x0 0x0 CDS 0x0 {ADDR}                |\n', '    29  |  37    |  CALLDATACOPY     |  0x0 {ADDR}                            |\n', '    2A  |  3d    |  RETURNDATASIZE   |  0x0 0x0 {ADDR}                        |\n', '    2B  |  3d    |  RETURNDATASIZE   |  0x0 0x0 0x0 {ADDR}                    |\n', '    2C  |  36    |  CALLDATASIZE     |  CDS 0x0 0x0 0x0 {ADDR}                |\n', '    2D  |  3d    |  RETURNDATASIZE   |  0x0 CDS 0x0 0x0 0x0 {ADDR}            |\n', '    2E  |  85    |  DUP6             |  {ADDR} 0x0 CDS 0x0 0x0 0x0 {ADDR}     |\n', '    2F  |  5a    |  GAS              |  GAS {ADDR} 0x0 CDS 0x0 0x0 0x0 {ADDR} |\n', '    30  |  f4    |  DELEGATECALL     |  {RES} 0x0 {ADDR}                      |\n', '\n', '    // We take the result of the call, load in the returndata,\n', '    // If call result == 0, failure, revert\n', '    // else success, return\n', '    POS | OPCODE |  OPCODE TEXT      |  STACK                               |\n', '    31  |  5b    |  JUMPDEST         |  {RES} 0x0 {ADDR}                    |\n', '    32  |  3d    |  RETURNDATASIZE   |  RDS {RES} 0x0 {ADDR}                |\n', '    33  |  82    |  DUP3             |  0x0 RDS {RES} 0x0 {ADDR}            |\n', '    34  |  80    |  DUP1             |  0x0 0x0 RDS {RES} 0x0 {ADDR}        |\n', '    35  |  3e    |  RETURNDATACOPY   |  {RES} 0x0 {ADDR}                    |\n', '    36  |  603c  |  PUSH1 0x3c       |  0x3c {RES} 0x0 {ADDR}               |\n', '    38  |  57    |  JUMPI            |  0x0 {ADDR}                          |\n', '    39  |  3d    |  RETURNDATASIZE   |  RDS 0x0 {ADDR}                      |\n', '    3A  |  81    |  DUP2             |  0x0 RDS 0x0 {ADDR}                  |\n', '    3B  |  fd    |  REVERT           |  0x0 {ADDR}                          |\n', '    3C  |  5b    |  JUMPDEST         |  0x0 {ADDR}                          |\n', '    3D  |  3d    |  RETURNDATASIZE   |  RDS 0x0 {ADDR}                      |\n', '    3E  |  81    |  DUP2             |  0x0 RDS 0x0 {ADDR}                  |\n', '    3F  |  f3    |  RETURN           |  0x0 {ADDR}                          |\n', '*/']