['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract Sales{\n', '\n', '\tenum ICOSaleState{\n', '\t    PrivateSale,\n', '\t    PreSale,\n', '\t    PreICO,\n', '\t    PublicICO\n', '\t}\n', '}\n', '\n', 'contract Utils{\n', '\n', '\t//verifies the amount greater than zero\n', '\n', '\tmodifier greaterThanZero(uint256 _value){\n', '\t\trequire(_value>0);\n', '\t\t_;\n', '\t}\n', '\n', '\t///verifies an address\n', '\n', '\tmodifier validAddress(address _add){\n', '\t\trequire(_add!=0x0);\n', '\t\t_;\n', '\t}\n', '}\n', '\n', '\n', '    \n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract SMTToken is Token,Ownable,Sales {\n', '    string public constant name = "Sun Money Token";\n', '    string public constant symbol = "SMT";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    ///The value to be sent to our BTC address\n', '    uint public valueToBeSent = 1;\n', '    ///The ethereum address of the person manking the transaction\n', '    address personMakingTx;\n', '    //uint private output1,output2,output3,output4;\n', '    ///to return the address just for the testing purposes\n', '    address public addr1;\n', '    ///to return the tx origin just for the testing purposes\n', '    address public txorigin;\n', '\n', '    //function for testing only btc address\n', '    bool isTesting;\n', '    ///testing the name remove while deploying\n', '    bytes32 testname;\n', '    address finalOwner;\n', '    bool public finalizedPublicICO = false;\n', '    bool public finalizedPreICO = false;\n', '\n', '    uint256 public SMTfundAfterPreICO;\n', '    uint256 public ethraised;\n', '    uint256 public btcraised;\n', '\n', '    bool public istransferAllowed;\n', '\n', '    uint256 public constant SMTfund = 10 * (10**6) * 10**decimals; \n', '    uint256 public fundingStartBlock; // crowdsale start block\n', '    uint256 public fundingEndBlock; // crowdsale end block\n', '    uint256 public  tokensPerEther = 150; //TODO\n', '    uint256 public  tokensPerBTC = 22*150*(10**10);\n', '    uint256 public tokenCreationMax= 72* (10**5) * 10**decimals; //TODO\n', '    mapping (address => bool) ownership;\n', '\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '      if(!istransferAllowed) throw;\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    //this is the default constructor\n', '    function SMTToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){\n', '        totalSupply = SMTfund;\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingEndBlock = _fundingEndBlock;\n', '    }\n', '\n', '\n', '    ICOSaleState public salestate = ICOSaleState.PrivateSale;\n', '\n', '    ///**To be replaced  the following by the following*///\n', '    /**\n', '\n', '    **/\n', '\n', '    /***Event to be fired when the state of the sale of the ICO is changes**/\n', '    event stateChange(ICOSaleState state);\n', '\n', '    /**\n', '\n', '    **/\n', '    function setState(ICOSaleState state)  returns (bool){\n', '    if(!ownership[msg.sender]) throw;\n', '    salestate = state;\n', '    stateChange(salestate);\n', '    return true;\n', '    }\n', '\n', '    /**\n', '\n', '    **/\n', '    function getState() returns (ICOSaleState) {\n', '    return salestate;\n', '\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {\n', '        if(!istransferAllowed) throw;\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function addToBalances(address _person,uint256 value) {\n', '        if(!ownership[msg.sender]) throw;\n', '        balances[_person] = SafeMath.add(balances[_person],value);\n', '\n', '    }\n', '\n', '    function addToOwnership(address owners) onlyOwner{\n', '        ownership[owners] = true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {\n', '        if(!istransferAllowed) throw;\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      if(!istransferAllowed) throw;\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseEthRaised(uint256 value){\n', '        if(!ownership[msg.sender]) throw;\n', '        ethraised+=value;\n', '    }\n', '\n', '    function increaseBTCRaised(uint256 value){\n', '        if(!ownership[msg.sender]) throw;\n', '        btcraised+=value;\n', '    }\n', '\n', '\n', '\n', '\n', '    function finalizePreICO(uint256 value) returns(bool){\n', '        if(!ownership[msg.sender]) throw;\n', '        finalizedPreICO = true;\n', '        SMTfundAfterPreICO =value;\n', '        return true;\n', '    }\n', '\n', '\n', '    function finalizePublicICO() returns(bool) {\n', '        if(!ownership[msg.sender]) throw;\n', '        finalizedPublicICO = true;\n', '        istransferAllowed = true;\n', '        return true;\n', '    }\n', '\n', '\n', '    function isValid() returns(bool){\n', '        if(block.number>=fundingStartBlock && block.number<fundingEndBlock ){\n', '            return true;\n', '        }else{\n', '            return false;\n', '        }\n', '    }\n', '\n', '    ///do not allow payments on this address\n', '\n', '    function() payable{\n', '        throw;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  modifier stopInEmergency {\n', '    if (paused) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '// Bitcoin transaction parsing library\n', '\n', '// Copyright 2016 rain <https://keybase.io/rain>\n', '//\n', '// Licensed under the Apache License, Version 2.0 (the "License");\n', '// you may not use this file except in compliance with the License.\n', '// You may obtain a copy of the License at\n', '//\n', '//      http://www.apache.org/licenses/LICENSE-2.0\n', '//\n', '// Unless required by applicable law or agreed to in writing, software\n', '// distributed under the License is distributed on an "AS IS" BASIS,\n', '// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '// See the License for the specific language governing permissions and\n', '// limitations under the License.\n', '\n', '// https://en.bitcoin.it/wiki/Protocol_documentation#tx\n', '//\n', '// Raw Bitcoin transaction structure:\n', '//\n', '// field     | size | type     | description\n', '// version   | 4    | int32    | transaction version number\n', '// n_tx_in   | 1-9  | var_int  | number of transaction inputs\n', '// tx_in     | 41+  | tx_in[]  | list of transaction inputs\n', '// n_tx_out  | 1-9  | var_int  | number of transaction outputs\n', '// tx_out    | 9+   | tx_out[] | list of transaction outputs\n', '// lock_time | 4    | uint32   | block number / timestamp at which tx locked\n', '//\n', '// Transaction input (tx_in) structure:\n', '//\n', '// field      | size | type     | description\n', '// previous   | 36   | outpoint | Previous output transaction reference\n', '// script_len | 1-9  | var_int  | Length of the signature script\n', '// sig_script | ?    | uchar[]  | Script for confirming transaction authorization\n', '// sequence   | 4    | uint32   | Sender transaction version\n', '//\n', '// OutPoint structure:\n', '//\n', '// field      | size | type     | description\n', '// hash       | 32   | char[32] | The hash of the referenced transaction\n', '// index      | 4    | uint32   | The index of this output in the referenced transaction\n', '//\n', '// Transaction output (tx_out) structure:\n', '//\n', '// field         | size | type     | description\n', '// value         | 8    | int64    | Transaction value (Satoshis)\n', '// pk_script_len | 1-9  | var_int  | Length of the public key script\n', '// pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.\n', '//\n', '// Variable integers (var_int) can be encoded differently depending\n', '// on the represented value, to save space. Variable integers always\n', '// precede an array of a variable length data type (e.g. tx_in).\n', '//\n', '// Variable integer encodings as a function of represented value:\n', '//\n', '// value           | bytes  | format\n', '// <0xFD (253)     | 1      | uint8\n', '// <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16\n', '// <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32\n', '// -               | 9      | 0xFF followed by length as uint64\n', '//\n', '// Public key scripts `pk_script` are set on the output and can\n', '// take a number of forms. The regular transaction script is\n', '// called &#39;pay-to-pubkey-hash&#39; (P2PKH):\n', '//\n', '// OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG\n', '//\n', '// OP_x are Bitcoin script opcodes. The bytes representation (including\n', '// the 0x14 20-byte stack push) is:\n', '//\n', '// 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC\n', '//\n', '// The <pubKeyHash> is the ripemd160 hash of the sha256 hash of\n', '// the public key, preceded by a network version byte. (21 bytes total)\n', '//\n', '// Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)\n', '//\n', '// The Bitcoin address is derived from the pubKeyHash. The binary form is the\n', '// pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes\n', '// of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)\n', '// This is converted to base58 to form the publicly used Bitcoin address.\n', '// Mainnet P2PKH transaction scripts are to addresses beginning with &#39;1&#39;.\n', '//\n', '// P2SH (&#39;pay to script hash&#39;) scripts only supply a script hash. The spender\n', '// must then provide the script that would allow them to redeem this output.\n', '// This allows for arbitrarily complex scripts to be funded using only a\n', '// hash of the script, and moves the onus on providing the script from\n', '// the spender to the redeemer.\n', '//\n', '// The P2SH script format is simple:\n', '//\n', '// OP_HASH160 <scriptHash> OP_EQUAL\n', '//\n', '// 0xA9 0x14 <scriptHash> 0x87\n', '//\n', '// The <scriptHash> is the ripemd160 hash of the sha256 hash of the\n', '// redeem script. The P2SH address is derived from the scriptHash.\n', '// Addresses are the scriptHash with a version prefix of 5, encoded as\n', '// Base58check. These addresses begin with a &#39;3&#39;.\n', '\n', '\n', '\n', '// parse a raw bitcoin transaction byte array\n', 'library BTC {\n', '    // Convert a variable integer into something useful and return it and\n', '    // the index to after it.\n', '    function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {\n', '        // the first byte tells us how big the integer is\n', '        var ibit = uint8(txBytes[pos]);\n', '        pos += 1;  // skip ibit\n', '\n', '        if (ibit < 0xfd) {\n', '            return (ibit, pos);\n', '        } else if (ibit == 0xfd) {\n', '            return (getBytesLE(txBytes, pos, 16), pos + 2);\n', '        } else if (ibit == 0xfe) {\n', '            return (getBytesLE(txBytes, pos, 32), pos + 4);\n', '        } else if (ibit == 0xff) {\n', '            return (getBytesLE(txBytes, pos, 64), pos + 8);\n', '        }\n', '    }\n', '    // convert little endian bytes to uint\n', '    function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {\n', '        if (bits == 8) {\n', '            return uint8(data[pos]);\n', '        } else if (bits == 16) {\n', '            return uint16(data[pos])\n', '                 + uint16(data[pos + 1]) * 2 ** 8;\n', '        } else if (bits == 32) {\n', '            return uint32(data[pos])\n', '                 + uint32(data[pos + 1]) * 2 ** 8\n', '                 + uint32(data[pos + 2]) * 2 ** 16\n', '                 + uint32(data[pos + 3]) * 2 ** 24;\n', '        } else if (bits == 64) {\n', '            return uint64(data[pos])\n', '                 + uint64(data[pos + 1]) * 2 ** 8\n', '                 + uint64(data[pos + 2]) * 2 ** 16\n', '                 + uint64(data[pos + 3]) * 2 ** 24\n', '                 + uint64(data[pos + 4]) * 2 ** 32\n', '                 + uint64(data[pos + 5]) * 2 ** 40\n', '                 + uint64(data[pos + 6]) * 2 ** 48\n', '                 + uint64(data[pos + 7]) * 2 ** 56;\n', '        }\n', '    }\n', '    // scan the full transaction bytes and return the first two output\n', '    // values (in satoshis) and addresses (in binary)\n', '    function getFirstTwoOutputs(bytes txBytes)\n', '             returns (uint, bytes20, uint, bytes20)\n', '    {\n', '        uint pos;\n', '        uint[] memory input_script_lens = new uint[](2);\n', '        uint[] memory output_script_lens = new uint[](2);\n', '        uint[] memory script_starts = new uint[](2);\n', '        uint[] memory output_values = new uint[](2);\n', '        bytes20[] memory output_addresses = new bytes20[](2);\n', '\n', '        pos = 4;  // skip version\n', '\n', '        (input_script_lens, pos) = scanInputs(txBytes, pos, 0);\n', '\n', '        (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);\n', '\n', '        for (uint i = 0; i < 2; i++) {\n', '            var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);\n', '            output_addresses[i] = pkhash;\n', '        }\n', '\n', '        return (output_values[0], output_addresses[0],\n', '                output_values[1], output_addresses[1]);\n', '    }\n', '    // Check whether `btcAddress` is in the transaction outputs *and*\n', '    // whether *at least* `value` has been sent to it.\n', '        // Check whether `btcAddress` is in the transaction outputs *and*\n', '    // whether *at least* `value` has been sent to it.\n', '    function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)\n', '             returns (bool,uint)\n', '    {\n', '        uint pos = 4;  // skip version\n', '        (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs\n', '\n', '        // scan *all* the outputs and find where they are\n', '        var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);\n', '\n', '        // look at each output and check whether it at least value to btcAddress\n', '        for (uint i = 0; i < output_values.length; i++) {\n', '            var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);\n', '            if (pkhash == btcAddress && output_values[i] >= value) {\n', '                return (true,output_values[i]);\n', '            }\n', '        }\n', '    }\n', '    // scan the inputs and find the script lengths.\n', '    // return an array of script lengths and the end position\n', '    // of the inputs.\n', '    // takes a &#39;stop&#39; argument which sets the maximum number of\n', '    // outputs to scan through. stop=0 => scan all.\n', '    function scanInputs(bytes txBytes, uint pos, uint stop)\n', '             returns (uint[], uint)\n', '    {\n', '        uint n_inputs;\n', '        uint halt;\n', '        uint script_len;\n', '\n', '        (n_inputs, pos) = parseVarInt(txBytes, pos);\n', '\n', '        if (stop == 0 || stop > n_inputs) {\n', '            halt = n_inputs;\n', '        } else {\n', '            halt = stop;\n', '        }\n', '\n', '        uint[] memory script_lens = new uint[](halt);\n', '\n', '        for (var i = 0; i < halt; i++) {\n', '            pos += 36;  // skip outpoint\n', '            (script_len, pos) = parseVarInt(txBytes, pos);\n', '            script_lens[i] = script_len;\n', '            pos += script_len + 4;  // skip sig_script, seq\n', '        }\n', '\n', '        return (script_lens, pos);\n', '    }\n', '    // scan the outputs and find the values and script lengths.\n', '    // return array of values, array of script lengths and the\n', '    // end position of the outputs.\n', '    // takes a &#39;stop&#39; argument which sets the maximum number of\n', '    // outputs to scan through. stop=0 => scan all.\n', '    function scanOutputs(bytes txBytes, uint pos, uint stop)\n', '             returns (uint[], uint[], uint[], uint)\n', '    {\n', '        uint n_outputs;\n', '        uint halt;\n', '        uint script_len;\n', '\n', '        (n_outputs, pos) = parseVarInt(txBytes, pos);\n', '\n', '        if (stop == 0 || stop > n_outputs) {\n', '            halt = n_outputs;\n', '        } else {\n', '            halt = stop;\n', '        }\n', '\n', '        uint[] memory script_starts = new uint[](halt);\n', '        uint[] memory script_lens = new uint[](halt);\n', '        uint[] memory output_values = new uint[](halt);\n', '\n', '        for (var i = 0; i < halt; i++) {\n', '            output_values[i] = getBytesLE(txBytes, pos, 64);\n', '            pos += 8;\n', '\n', '            (script_len, pos) = parseVarInt(txBytes, pos);\n', '            script_starts[i] = pos;\n', '            script_lens[i] = script_len;\n', '            pos += script_len;\n', '        }\n', '\n', '        return (output_values, script_starts, script_lens, pos);\n', '    }\n', '    // Slice 20 contiguous bytes from bytes `data`, starting at `start`\n', '    function sliceBytes20(bytes data, uint start) returns (bytes20) {\n', '        uint160 slice = 0;\n', '        for (uint160 i = 0; i < 20; i++) {\n', '            slice += uint160(data[i + start]) << (8 * (19 - i));\n', '        }\n', '        return bytes20(slice);\n', '    }\n', '    // returns true if the bytes located in txBytes by pos and\n', '    // script_len represent a P2PKH script\n', '    function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {\n', '        return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script\n', '            && (txBytes[pos] == 0x76)       // OP_DUP\n', '            && (txBytes[pos + 1] == 0xa9)   // OP_HASH160\n', '            && (txBytes[pos + 2] == 0x14)   // bytes to push\n', '            && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY\n', '            && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG\n', '    }\n', '    // returns true if the bytes located in txBytes by pos and\n', '    // script_len represent a P2SH script\n', '    function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {\n', '        return (script_len == 23)           // 20 byte scripthash + 3 bytes of script\n', '            && (txBytes[pos + 0] == 0xa9)   // OP_HASH160\n', '            && (txBytes[pos + 1] == 0x14)   // bytes to push\n', '            && (txBytes[pos + 22] == 0x87); // OP_EQUAL\n', '    }\n', '    // Get the pubkeyhash / scripthash from an output script. Assumes\n', '    // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.\n', '    // Returns the pubkeyhash/ scripthash, or zero if unknown output.\n', '    function parseOutputScript(bytes txBytes, uint pos, uint script_len)\n', '             returns (bytes20)\n', '    {\n', '        if (isP2PKH(txBytes, pos, script_len)) {\n', '            return sliceBytes20(txBytes, pos + 3);\n', '        } else if (isP2SH(txBytes, pos, script_len)) {\n', '            return sliceBytes20(txBytes, pos + 2);\n', '        } else {\n', '            return;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract PricingStrategy{\n', '\n', '\t/**\n', '\treturns the base discount value\n', '\t@param  currentsupply is a &#39;current supply&#39; value\n', '\t@param  contribution  is &#39;sent by the contributor&#39;\n', '\t@return   an integer for getting the discount value of the base discounts\n', '\t**/\n', '\tfunction baseDiscounts(uint256 currentsupply,uint256 contribution,string types) returns (uint256){\n', '\t\tif(contribution==0) throw;\n', '\t\tif(keccak256("ethereum")==keccak256(types)){\n', '\t\t\tif(currentsupply>=0 && currentsupply<= 15*(10**5) * (10**18) && contribution>=1*10**18){\n', '\t\t\t return 40;\n', '\t\t\t}else if(currentsupply> 15*(10**5) * (10**18) && currentsupply< 30*(10**5) * (10**18) && contribution>=5*10**17){\n', '\t\t\t\treturn 30;\n', '\t\t\t}else{\n', '\t\t\t\treturn 0;\n', '\t\t\t}\n', '\t\t\t}else if(keccak256("bitcoin")==keccak256(types)){\n', '\t\t\t\tif(currentsupply>=0 && currentsupply<= 15*(10**5) * (10**18) && contribution>=45*10**5){\n', '\t\t\t\t return 40;\n', '\t\t\t\t}else if(currentsupply> 15*(10**5) * (10**18) && currentsupply< 30*(10**5) * (10**18) && contribution>=225*10**4){\n', '\t\t\t\t\treturn 30;\n', '\t\t\t\t}else{\n', '\t\t\t\t\treturn 0;\n', '\t\t\t\t}\n', '\t\t\t}\t\n', '\t}\n', '\n', '\t/**\n', '\t\n', '\tThese are the base discounts offered by the sunMOneyToken\n', '\tThese are valid ffor every value sent to the contract\n', '\t@param   contribution is a &#39;the value sent in wei by the contributor in ethereum&#39;\n', '\t@return  the discount\n', '\t**/\n', '\tfunction volumeDiscounts(uint256 contribution,string types) returns (uint256){\n', '\t\t///do not allow the zero contrbution \n', '\t\t//its unsigned negative checking not required\n', '\t\tif(contribution==0) throw;\n', '\t\tif(keccak256("ethereum")==keccak256(types)){\n', '\t\t\tif(contribution>=3*10**18 && contribution<10*10**18){\n', '\t\t\t\treturn 0;\n', '\t\t\t}else if(contribution>=10*10**18 && contribution<20*10**18){\n', '\t\t\t\treturn 5;\n', '\t\t\t}else if(contribution>=20*10**18){\n', '\t\t\t\treturn 10;\n', '\t\t\t}else{\n', '\t\t\t\treturn 0;\n', '\t\t\t}\n', '\t\t\t}else if(keccak256("bitcoin")==keccak256(types)){\n', '\t\t\t\tif(contribution>=3*45*10**5 && contribution<10*45*10**5){\n', '\t\t\t\t\treturn 0;\n', '\t\t\t\t}else if(contribution>=10*45*10**5 && contribution<20*45*10**5){\n', '\t\t\t\t\treturn 5;\n', '\t\t\t\t}else if(contribution>=20*45*10**5){\n', '\t\t\t\t\treturn 10;\n', '\t\t\t\t}else{\n', '\t\t\t\t\treturn 0;\n', '\t\t\t\t}\n', '\t\t\t}\n', '\n', '\t}\n', '\n', '\t/**returns the total discount value**/\n', '\t/**\n', '\t@param  currentsupply is a &#39;current supply&#39;\n', '\t@param  contribution is a &#39;sent by the contributor&#39;\n', '\t@return   an integer for getting the total discounts\n', '\t**/\n', '\tfunction totalDiscount(uint256 currentsupply,uint256 contribution,string types) returns (uint256){\n', '\t\tuint256 basediscount = baseDiscounts(currentsupply,contribution,types);\n', '\t\tuint256 volumediscount = volumeDiscounts(contribution,types);\n', '\t\tuint256 totaldiscount = basediscount+volumediscount;\n', '\t\treturn totaldiscount;\n', '\t}\n', '}\n', '\n', '\n', '\n', 'contract PreICO is Ownable,Pausable, Utils,PricingStrategy,Sales{\n', '\n', '\tSMTToken token;\n', '\tuint256 public tokensPerBTC;\n', '\tuint public tokensPerEther;\n', '\tuint256 public initialSupplyPrivateSale;\n', '\tuint256 public initialSupplyPreSale;\n', '\tuint256 public SMTfundAfterPreICO;\n', '\tuint256 public initialSupplyPublicPreICO;\n', '\tuint256 public currentSupply;\n', '\tuint256 public fundingStartBlock;\n', '\tuint256 public fundingEndBlock;\n', '\tuint256 public SMTfund;\n', '\tuint256 public tokenCreationMaxPreICO = 15* (10**5) * 10**18;\n', '\tuint256 public tokenCreationMaxPrivateSale = 15*(10**5) * (10**18);\n', '\t///tokens for the team\n', '\tuint256 public team = 1*(10**6)*(10**18);\n', '\t///tokens for reserve\n', '\tuint256 public reserve = 1*(10**6)*(10**18);\n', '\t///tokens for the mentors\n', '\tuint256 public mentors = 5*(10**5)*10**18;\n', '\t///tokkens for the bounty\n', '\tuint256 public bounty = 3*(10**5)*10**18;\n', '\t///address for the teeam,investores,etc\n', '\n', '\tuint256 totalsend = team+reserve+bounty+mentors;\n', '\taddress public addressPeople = 0xea0f17CA7C3e371af30EFE8CbA0e646374552e8B;\n', '\n', '\taddress public ownerAddr = 0x4cA09B312F23b390450D902B21c7869AA64877E3;\n', '\t///array of addresses for the ethereum relateed back funding  contract\n', '\tuint256 public numberOfBackers;\n', '\t///the txorigin is the web3.eth.coinbase account\n', '\t//record Transactions that have claimed ether to prevent the replay attacks\n', '\t//to-do\n', '\tmapping(uint256 => bool) transactionsClaimed;\n', '\tuint256 public valueToBeSent;\n', '\n', '\t//the constructor function\n', '   function PreICO(address tokenAddress){\n', '\t\t//require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input\n', '\t\ttoken = SMTToken(tokenAddress);\n', '\t\ttokensPerEther = token.tokensPerEther();\n', '\t\ttokensPerBTC = token.tokensPerBTC();\n', '\t\tvalueToBeSent = token.valueToBeSent();\n', '\t\tSMTfund = token.SMTfund();\n', '\t}\n', '\t\n', '\t////function to send initialFUnd\n', '    function sendFunds() onlyOwner{\n', '        token.addToBalances(addressPeople,totalsend);\n', '    }\n', '\n', '\t///a function using safemath to work with\n', '\t///the new function\n', '\tfunction calNewTokens(uint256 contribution,string types) returns (uint256){\n', '\t\tuint256 disc = totalDiscount(currentSupply,contribution,types);\n', '\t\tuint256 CreatedTokens;\n', '\t\tif(keccak256(types)==keccak256("ethereum")) CreatedTokens = SafeMath.mul(contribution,tokensPerEther);\n', '\t\telse if(keccak256(types)==keccak256("bitcoin"))  CreatedTokens = SafeMath.mul(contribution,tokensPerBTC);\n', '\t\tuint256 tokens = SafeMath.add(CreatedTokens,SafeMath.div(SafeMath.mul(CreatedTokens,disc),100));\n', '\t\treturn tokens;\n', '\t}\n', '\t/**\n', '\t\tPayable function to send the ether funds\n', '\t**/\n', '\tfunction() external payable stopInEmergency{\n', '        if(token.getState()==ICOSaleState.PublicICO) throw;\n', '        bool isfinalized = token.finalizedPreICO();\n', '        bool isValid = token.isValid();\n', '        if(isfinalized) throw;\n', '        if(!isValid) throw;\n', '        if (msg.value == 0) throw;\n', '        uint256 newCreatedTokens;\n', '        ///since we are creating tokens we need to increase the total supply\n', '        if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {\n', '        \tif((msg.value) < 1*10**18) throw;\n', '        \tnewCreatedTokens =calNewTokens(msg.value,"ethereum");\n', '        \tuint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '        \tif(temp>tokenCreationMaxPrivateSale){\n', '        \t\tuint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);\n', '        \t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,consumed);\n', '        \t\tuint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);\n', '        \t\tuint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));\n', '        \t\tswitchState();\n', '        \t\tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,finalTokens);\n', '        \t\tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \t\tnumberOfBackers++;\n', '               token.addToBalances(msg.sender,SafeMath.add(finalTokens,consumed));\n', '        \t if(!ownerAddr.send(msg.value))throw;\n', '        \t  token.increaseEthRaised(msg.value);\n', '        \t}else{\n', '    \t\t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '    \t\t\tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '    \t\t\tif(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;\n', '    \t\t\tnumberOfBackers++;\n', '                token.addToBalances(msg.sender,newCreatedTokens);\n', '            \tif(!ownerAddr.send(msg.value))throw;\n', '            \ttoken.increaseEthRaised(msg.value);\n', '    \t\t}\n', '        }\n', '        else if(token.getState()==ICOSaleState.PreICO){\n', '        \tif(msg.value < 5*10**17) throw;\n', '        \tnewCreatedTokens =calNewTokens(msg.value,"ethereum");\n', '        \tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);\n', '        \tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '        \tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \tnumberOfBackers++;\n', '             token.addToBalances(msg.sender,newCreatedTokens);\n', '        \tif(!ownerAddr.send(msg.value))throw;\n', '        \ttoken.increaseEthRaised(msg.value);\n', '        }\n', '\n', '\t}\n', '\n', '\t///token distribution initial function for the one in the exchanges\n', '\t///to be done only the owner can run this function\n', '\tfunction tokenAssignExchange(address addr,uint256 val,uint256 txnHash) public onlyOwner {\n', '\t   // if(msg.sender!=owner) throw;\n', '\t  if (val == 0) throw;\n', '\t  if(token.getState()==ICOSaleState.PublicICO) throw;\n', '\t  if(transactionsClaimed[txnHash]) throw;\n', '\t  bool isfinalized = token.finalizedPreICO();\n', '\t  if(isfinalized) throw;\n', '\t  bool isValid = token.isValid();\n', '\t  if(!isValid) throw;\n', '\t  uint256 newCreatedTokens;\n', '        if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {\n', '        \tif(val < 1*10**18) throw;\n', '        \tnewCreatedTokens =calNewTokens(val,"ethereum");\n', '        \tuint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '        \tif(temp>tokenCreationMaxPrivateSale){\n', '        \t\tuint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);\n', '        \t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,consumed);\n', '        \t\tuint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);\n', '        \t\tuint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));\n', '        \t\tswitchState();\n', '        \t\tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,finalTokens);\n', '        \t\tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \t\tnumberOfBackers++;\n', '               token.addToBalances(addr,SafeMath.add(finalTokens,consumed));\n', '        \t   token.increaseEthRaised(val);\n', '        \t}else{\n', '    \t\t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '    \t\t\tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '    \t\t\tif(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;\n', '    \t\t\tnumberOfBackers++;\n', '                token.addToBalances(addr,newCreatedTokens);\n', '            \ttoken.increaseEthRaised(val);\n', '    \t\t}\n', '        }\n', '        else if(token.getState()==ICOSaleState.PreICO){\n', '        \tif(msg.value < 5*10**17) throw;\n', '        \tnewCreatedTokens =calNewTokens(val,"ethereum");\n', '        \tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);\n', '        \tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '        \tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \tnumberOfBackers++;\n', '             token.addToBalances(addr,newCreatedTokens);\n', '        \ttoken.increaseEthRaised(val);\n', '        }\n', '\t}\n', '\n', '\t//Token distribution for the case of the ICO\n', '\t///function to run when the transaction has been veified\n', '\tfunction processTransaction(bytes txn, uint256 txHash,address addr,bytes20 btcaddr) onlyOwner returns (uint)\n', '\t{\n', '\t\tbool valueSent;\n', '\t\tbool isValid = token.isValid();\n', '\t\tif(!isValid) throw;\n', '\t\t//txorigin = tx.origin;\n', '\t\t//\tif(token.getState()!=State.Funding) throw;\n', '\t\tif(!transactionsClaimed[txHash]){\n', '\t\t\tvar (a,b) = BTC.checkValueSent(txn,btcaddr,valueToBeSent);\n', '\t\t\tif(a){\n', '\t\t\t\tvalueSent = true;\n', '\t\t\t\ttransactionsClaimed[txHash] = true;\n', '\t\t\t\tuint256 newCreatedTokens;\n', '\t\t\t\t ///since we are creating tokens we need to increase the total supply\n', '            if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {\n', '        \tif(b < 45*10**5) throw;\n', '        \tnewCreatedTokens =calNewTokens(b,"bitcoin");\n', '        \tuint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '        \tif(temp>tokenCreationMaxPrivateSale){\n', '        \t\tuint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);\n', '        \t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,consumed);\n', '        \t\tuint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);\n', '        \t\tuint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));\n', '        \t\tswitchState();\n', '        \t\tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);\n', '        \t\tcurrentSupply = SafeMath.add(currentSupply,finalTokens);\n', '        \t\tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \t\tnumberOfBackers++;\n', '               token.addToBalances(addr,SafeMath.add(finalTokens,consumed));\n', '        \t   token.increaseBTCRaised(b);\n', '        \t}else{\n', '    \t\t\tinitialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);\n', '    \t\t\tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '    \t\t\tif(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;\n', '    \t\t\tnumberOfBackers++;\n', '                token.addToBalances(addr,newCreatedTokens);\n', '            \ttoken.increaseBTCRaised(b);\n', '    \t\t}\n', '        }\n', '        else if(token.getState()==ICOSaleState.PreICO){\n', '        \tif(msg.value < 225*10**4) throw;\n', '        \tnewCreatedTokens =calNewTokens(b,"bitcoin");\n', '        \tinitialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);\n', '        \tcurrentSupply = SafeMath.add(currentSupply,newCreatedTokens);\n', '        \tif(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;\n', '        \tnumberOfBackers++;\n', '             token.addToBalances(addr,newCreatedTokens);\n', '        \ttoken.increaseBTCRaised(b);\n', '         }\n', '\t\treturn 1;\n', '\t\t\t}\n', '\t\t}\n', '\t\telse{\n', '\t\t    throw;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction finalizePreICO() public onlyOwner{\n', '\t\tuint256 val = currentSupply;\n', '\t\ttoken.finalizePreICO(val);\n', '\t}\n', '\n', '\tfunction switchState() internal  {\n', '\t\t token.setState(ICOSaleState.PreICO);\n', '\t\t\n', '\t}\n', '\t\n', '\n', '\t\n', '\n', '}']