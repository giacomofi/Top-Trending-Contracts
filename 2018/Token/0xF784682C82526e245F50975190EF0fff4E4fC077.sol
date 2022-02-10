['pragma solidity 0.4.24;\n', '/*\n', '    Owner\n', '    owned.sol\n', '    1.0.1\n', '*/\n', '\n', 'contract Owned {\n', '    /* Variables */\n', '    address public owner = msg.sender;\n', '    /* Constructor */\n', '    constructor(address _owner) public {\n', '        if ( _owner == 0x00 ) {\n', '            _owner = msg.sender;\n', '        }\n', '        owner = _owner;\n', '    }\n', '    /* Externals */\n', '    function replaceOwner(address _owner) external returns(bool) {\n', '        require( isOwner() );\n', '        owner = _owner;\n', '        return true;\n', '    }\n', '    /* Internals */\n', '    function isOwner() internal view returns(bool) {\n', '        return owner == msg.sender;\n', '    }\n', '    /* Modifiers */\n', '    modifier forOwner {\n', '        require( isOwner() );\n', '        _;\n', '    }\n', '}\n', '/*\n', '    Safe mathematical operations\n', '    safeMath.sol\n', '    1.0.0\n', '*/\n', '\n', 'library SafeMath {\n', '    /* Internals */\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a + b;\n', '        assert( c >= a );\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a - b;\n', '        assert( c <= a );\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a * b;\n', '        assert( c == 0 || c / a == b );\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a / b;\n', '    }\n', '    function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a ** b;\n', '        assert( c % a == 0 );\n', '        return a ** b;\n', '    }\n', '}\n', 'contract TokenDB {}\n', 'contract Ico {}\n', '/*\n', '    Token Proxy\n', '    token.sol\n', '    1.0.2\n', '*/\n', '\n', 'contract Token is Owned {\n', '    /* Declarations */\n', '    using SafeMath for uint256;\n', '    /* Variables */\n', '    string  public name = "Inlock token";\n', '    string  public symbol = "ILK";\n', '    uint8   public decimals = 8;\n', '    uint256 public totalSupply = 44e16;\n', '    address public libAddress;\n', '    TokenDB public db;\n', '    Ico public ico;\n', '    /* Constructor */\n', '    constructor(address _owner, address _libAddress, address _dbAddress, address _icoAddress) Owned(_owner) public {\n', '        libAddress = _libAddress;\n', '        db = TokenDB(_dbAddress);\n', '        ico = Ico(_icoAddress);\n', '        emit Mint(_icoAddress, totalSupply);\n', '    }\n', '    /* Fallback */\n', '    function () public { revert(); }\n', '    /* Externals */\n', '    function changeLibAddress(address _libAddress) external forOwner {\n', '        libAddress = _libAddress;\n', '    }\n', '    function changeDBAddress(address _dbAddress) external forOwner {\n', '        db = TokenDB(_dbAddress);\n', '    }\n', '    function changeIcoAddress(address _icoAddress) external forOwner {\n', '        ico = Ico(_icoAddress);\n', '    }\n', '    function approve(address _spender, uint256 _value) external returns (bool _success) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    function transfer(address _to, uint256 _amount) external returns (bool _success) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool _success) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    /* Constants */\n', '    function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    function balanceOf(address _owner) public view returns (uint256 _balance) {\n', '        address _trg = libAddress;\n', '        assembly {\n', '            let m := mload(0x40)\n', '            calldatacopy(m, 0, calldatasize)\n', '            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)\n', '            switch success case 0 {\n', '                revert(0, 0)\n', '            } default {\n', '                return(m, 0x20)\n', '            }\n', '        }\n', '    }\n', '    /* Events */\n', '    event AllowanceUsed(address indexed _spender, address indexed _owner, uint256 indexed _value);\n', '    event Mint(address indexed _addr, uint256 indexed _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '}']