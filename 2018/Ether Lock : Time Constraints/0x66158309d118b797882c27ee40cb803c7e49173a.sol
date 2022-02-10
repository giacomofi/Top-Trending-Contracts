['pragma solidity ^0.4.24;\n', '\n', 'contract IBancorConverter {\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);\n', '}\n', '\n', 'contract IExchange {\n', '    function ethToTokens(uint _ethAmount) public view returns(uint);\n', '    function tokenToEth(uint _amountOfTokens) public view returns(uint);\n', '    function tokenToEthRate() public view returns(uint);\n', '    function ethToTokenRate() public view returns(uint);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Exchange is Owned, IExchange {\n', '    using SafeMath for uint;\n', '\n', '    IBancorConverter public bntConverter;\n', '    IBancorConverter public tokenConverter;\n', '\n', '    address public ethToken;\n', '    address public bntToken;\n', '    address public token;\n', '\n', '    event Initialized(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token);\n', '\n', '    constructor() public { \n', '    }\n', '\n', '    function initialize(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token) external onlyOwner {\n', '       bntConverter = IBancorConverter(_bntConverter);\n', '       tokenConverter = IBancorConverter(_tokenConverter);\n', '\n', '       ethToken = _ethToken;\n', '       bntToken = _bntToken;\n', '       token = _token;\n', '\n', '       emit Initialized(_bntConverter, _tokenConverter, _ethToken, _bntToken, _token);\n', '    }\n', '\n', '    function ethToTokens(uint _ethAmount) public view returns(uint) {\n', '        uint bnt = bntConverter.getReturn(ethToken, bntToken, _ethAmount);\n', '        uint amountOfTokens = tokenConverter.getReturn(bntToken, token, bnt);\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function tokenToEth(uint _amountOfTokens) public view returns(uint) {\n', '        uint bnt = tokenConverter.getReturn(token, bntToken, _amountOfTokens);\n', '        uint eth = bntConverter.getReturn(bntToken, ethToken, bnt);\n', '        return eth;\n', '    }\n', '\n', '    function tokenToEthRate() public view returns(uint) {\n', '        uint eth = tokenToEth(1 ether);\n', '        return eth;\n', '    }\n', '\n', '    function ethToTokenRate() public view returns(uint) {\n', '        uint tkn = ethToTokens(1 ether);\n', '        return tkn;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract IBancorConverter {\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);\n', '}\n', '\n', 'contract IExchange {\n', '    function ethToTokens(uint _ethAmount) public view returns(uint);\n', '    function tokenToEth(uint _amountOfTokens) public view returns(uint);\n', '    function tokenToEthRate() public view returns(uint);\n', '    function ethToTokenRate() public view returns(uint);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'contract Exchange is Owned, IExchange {\n', '    using SafeMath for uint;\n', '\n', '    IBancorConverter public bntConverter;\n', '    IBancorConverter public tokenConverter;\n', '\n', '    address public ethToken;\n', '    address public bntToken;\n', '    address public token;\n', '\n', '    event Initialized(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token);\n', '\n', '    constructor() public { \n', '    }\n', '\n', '    function initialize(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token) external onlyOwner {\n', '       bntConverter = IBancorConverter(_bntConverter);\n', '       tokenConverter = IBancorConverter(_tokenConverter);\n', '\n', '       ethToken = _ethToken;\n', '       bntToken = _bntToken;\n', '       token = _token;\n', '\n', '       emit Initialized(_bntConverter, _tokenConverter, _ethToken, _bntToken, _token);\n', '    }\n', '\n', '    function ethToTokens(uint _ethAmount) public view returns(uint) {\n', '        uint bnt = bntConverter.getReturn(ethToken, bntToken, _ethAmount);\n', '        uint amountOfTokens = tokenConverter.getReturn(bntToken, token, bnt);\n', '        return amountOfTokens;\n', '    }\n', '\n', '    function tokenToEth(uint _amountOfTokens) public view returns(uint) {\n', '        uint bnt = tokenConverter.getReturn(token, bntToken, _amountOfTokens);\n', '        uint eth = bntConverter.getReturn(bntToken, ethToken, bnt);\n', '        return eth;\n', '    }\n', '\n', '    function tokenToEthRate() public view returns(uint) {\n', '        uint eth = tokenToEth(1 ether);\n', '        return eth;\n', '    }\n', '\n', '    function ethToTokenRate() public view returns(uint) {\n', '        uint tkn = ethToTokens(1 ether);\n', '        return tkn;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}']
