['pragma solidity ^0.5.2;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b != 0);\n', '        c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract FSCToken is owned {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 6; \n', '    uint256 public totalSupply;\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    //Token Basic\n', '    constructor() public {\n', '        totalSupply = 1e8 * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;                   \n', '        name = "Four S Coin";                                      \n', '        symbol = "FSC";\n', '    }\n', '\n', '    function balanceOfcheck(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    //Transfer\n', '    function _transfer(address _from, address _to, uint _value) internal returns (bool) {\n', '        require(_to != address(0x0));\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    //approve&check\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowancecheck(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowance[_owner][_spender];\n', '    }\n', '    \n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    \n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowance[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowance[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '        return true;\n', '      }\n', '\n', '    //Mint&Burn Token\n', '    function mintToken(uint256 mintedAmount) onlyOwner public {\n', '        uint mint=mintedAmount.mul(1e6);\n', '        balanceOf[owner] += mint;\n', '        totalSupply += mint;\n', '        emit Transfer(address(this), owner, mint);\n', '    }\n', '\n', '    function burnToken(uint256 burnAmount)onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= burnAmount);   \n', '        uint burn=burnAmount.mul(1e6);\n', '        balanceOf[owner] -= burn;            \n', '        totalSupply -= burn;                      \n', '        emit Burn(owner, burnAmount);\n', '        return true;\n', '    }\n', '    \n', '    mapping(bytes => bool) signatures;\n', '    event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);\n', '    \n', '    //transferPreSigned\n', '    function transferPreSigned(\n', '    bytes memory _signature,\n', '    address _to,\n', '    uint256 _value,\n', '    uint256 _fee,\n', '    uint _nonc)public returns (bool)\n', '    \n', '    {\n', '        require(_to != address(0));\n', '        require(signatures[_signature] == false);\n', '        bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee,_nonc);\n', '        address from = recover(hashedTx, _signature);\n', '        require(from != address(0));\n', '        balanceOf[from] = balanceOf[from].sub(_value).sub(_fee);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(_fee);\n', '        signatures[_signature] = true;\n', '        emit Transfer(from, _to, _value);\n', '        emit Transfer(from, msg.sender, _fee);\n', '        emit TransferPreSigned(from, _to, msg.sender, _value, _fee);\n', '        return true;\n', '    }\n', '    \n', '    function transferPreSignedHashing(\n', '        address _token,\n', '        address _to,\n', '        uint256 _value,\n', '        uint256 _fee,\n', '        uint _nonc\n', '    )\n', '        public\n', '        pure\n', '        returns (bytes32)\n', '    {\n', '        /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */\n', '        return (keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee,_nonc)));\n', '    }\n', '    \n', '    function recover(bytes32 hash, bytes memory sig) public pure returns (address) {\n', '      bytes32  r;\n', '      bytes32  s;\n', '      uint8 v;\n', '       //Check the signature length\n', '      if (sig.length != 65) {\n', '        return (address(0));\n', '      }\n', '       // Divide the signature in r, s and v variables\n', '      assembly {\n', '        r := mload(add(sig, 32))\n', '        s := mload(add(sig, 64))\n', '        v := byte(0, mload(add(sig, 96)))\n', '      }\n', '       // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '      if (v < 27) {\n', '        v += 27;\n', '      }\n', '       // If the version is correct return the signer address\n', '      if (v != 27 && v != 28) {\n', '        return (address(0));\n', '      } else {\n', '        return ecrecover(hash, v, r, s);\n', '      }\n', '    }\n', '}']