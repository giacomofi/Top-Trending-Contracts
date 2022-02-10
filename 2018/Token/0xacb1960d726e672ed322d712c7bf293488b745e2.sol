['pragma solidity 0.4.24;\n', '\n', '/****************************************************************************\n', '*                   ******MAJz Token Smart Contract******                   *\n', '*                   Symbol      :   MAZ                                     *\n', '*                   Name        :   MAJz                                    *\n', '*                   Total Supply:   560 000 000                             *\n', '*                   Decimals    :   18                                      *\n', '*                   Almar Blockchain Technology                             *\n', '*                   *************************************                   *\n', '****************************************************************************/\n', '\n', '/****************************************************************************\n', '*                       Ownership Contract                                  *\n', '*                       for authorization Control                           *\n', '*                       and 0x0 Validation                                  *\n', '****************************************************************************/\n', 'contract Ownership {\n', '    address public _owner;\n', '\n', '    modifier onlyOwner() { require(msg.sender == _owner); _; }\n', '    modifier validDestination( address to ) { require(to != address(0x0)); _; }\n', '}\n', '\n', '/****************************************************************************\n', '*                       Safemath Library                                    *\n', '*                       to prevent Over / Underflow                         *\n', '****************************************************************************/\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b; assert(c >= a); return c; }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) { assert(b <= a); return a - b; }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0){return 0;} c = a * b; assert(c / a == b); return c; }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) { return a / b; }\n', '}\n', '\n', '/****************************************************************************\n', '*                   Basic Token Interface                                   *\n', '*                   Contains Standart Token Functionalities                 *\n', '****************************************************************************/\n', '\n', 'contract BasicToken {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address owner) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/****************************************************************************\n', '*                   Token Smart Contract                                    *\n', '****************************************************************************/\n', '\n', 'contract MAJz is BasicToken, Ownership {\n', '    using SafeMath for uint256;\n', '\n', '    string public _symbol;\n', '    string public _name;\n', '    uint256 public _decimals;\n', '    uint256 public _totalSupply;\n', '\n', '    mapping(address => uint256) public _balances;\n', '    \n', '\n', '    //Constructor of the Token\n', '    constructor() public{\n', '        _symbol = "MAZ";\n', '        _name = "MAJz";\n', '        _decimals = 18;\n', '        _totalSupply = 560000000000000000000000000;\n', '        _balances[msg.sender] = _totalSupply;\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    //Returns the totalSupply\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    //Return the balance of an specified account\n', '    function balanceOf(address targetAddress) public view returns (uint256) {\n', '        return _balances[targetAddress];\n', '    }\n', '    \n', '    //Transfer function. Validates targetAdress not to be 0x0\n', '    function transfer(address targetAddress, uint256 value) validDestination(targetAddress) public returns (bool) {\n', '        _balances[msg.sender] = SafeMath.sub(_balances[msg.sender], value); //SafeMath will throw if value > balance\n', '        _balances[targetAddress] = SafeMath.add(_balances[targetAddress], value);\n', '        emit Transfer(msg.sender, targetAddress, value); \n', '        return true; \n', '    }\n', '\n', '    //Burn some of the tokens\n', '    function burnTokens(uint256 value) public onlyOwner returns (bool){\n', '        _balances[_owner] = SafeMath.sub(_balances[_owner], value); //SafeMath will throw if value > balance\n', '        _totalSupply = SafeMath.sub(_totalSupply, value); \n', '        emit BurnTokens(value);\n', '        return true;\n', '    }\n', '\n', '    //Emit new tokens\n', '    function emitTokens(uint256 value) public onlyOwner returns (bool){\n', '        _balances[_owner] = SafeMath.add(_balances[_owner], value); //SafeMath will throw if Overflow\n', '        _totalSupply = SafeMath.add(_totalSupply, value);\n', '        emit EmitTokens(value);\n', '        return true;\n', '    }\n', '\n', '    //Revert a transfer in case of error\n', '    function revertTransfer (address targetAddress, uint256 value) public onlyOwner returns (bool){\n', '        _balances[targetAddress] = SafeMath.sub(_balances[targetAddress], value);\n', '        _balances[_owner] = SafeMath.add(_balances[_owner], value);\n', '        emit RevertTransfer(targetAddress, value);\n', '        return true;\n', '    }\n', '    event BurnTokens(uint256 value);\n', '    event EmitTokens(uint256 value);\n', '    event RevertTransfer(address targetAddress, uint256 value);\n', '}']