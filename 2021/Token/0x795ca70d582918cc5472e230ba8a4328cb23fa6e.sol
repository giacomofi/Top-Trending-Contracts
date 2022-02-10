['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-05\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', ' library SafeMath256 {\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '   require( b<= a,"Sub Error");\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a,"Add Error");\n', '\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract ERC20 {\n', '\t   event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '       event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '\n', '   \t \n', '       function balanceOf(address tokenOwner) public view returns (uint256 balance);\n', '       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);\n', '\n', '       function transfer(address to, uint256 tokens) public returns (bool success);\n', '       \n', '       function approve(address spender, uint256 tokens) public returns (bool success);\n', '       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);\n', '       \n', '\n', '}\n', '\n', 'contract StandardERC20 is ERC20{\n', '     using SafeMath256 for uint256; \n', '     uint256 public totalSupply;\n', '     \n', '     mapping (address => uint256) balance;\n', '     mapping (address => mapping (address=>uint256)) allowed;\n', '\n', '\n', '     function balanceOf(address _walletAddress) public view returns (uint256){\n', '        return balance[_walletAddress]; \n', '     }\n', '\n', '\n', '     function allowance(address _owner, address _spender) public view returns (uint256){\n', '          return allowed[_owner][_spender];\n', '        }\n', '\n', '     function transfer(address _to, uint256 _value) public returns (bool){\n', '        require(_value <= balance[msg.sender],"Insufficient Balance");\n', '      //  require(_to != address(0),"Can\'t transfer To Address 0");\n', '\n', '        balance[msg.sender] = balance[msg.sender].sub(_value);\n', '        balance[_to] = balance[_to].add(_value);\n', '        emit Transfer(msg.sender,_to,_value);\n', '        \n', '        return true;\n', '\n', '     }\n', '\n', '     function approve(address _spender, uint256 _value)\n', '            public returns (bool){\n', '            allowed[msg.sender][_spender] = _value;\n', '\n', '            emit Approval(msg.sender, _spender, _value);\n', '            return true;\n', '            }\n', '\n', '      function transferFrom(address _from, address _to, uint256 _value)\n', '            public returns (bool){\n', '               require(_value <= balance[_from],"Insufficient Balance");\n', '               require(_value <= allowed[_from][msg.sender],"Insufficient Balance allowed"); \n', '        //       require(_to != address(0));\n', '\n', '              balance[_from] = balance[_from].sub(_value);\n', '              balance[_to] = balance[_to].add(_value);\n', '              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '              emit Transfer(_from, _to, _value);\n', '              return true;\n', '      }\n', '}\n', '\n', 'contract FANSTOKEN is StandardERC20{\n', '  string public name = "FANS Token";\n', '  string public symbol = "FANS"; \n', '  uint256 public decimals = 18;\n', '  uint256 public HARD_CAP = 300000000 ether; \n', '  \n', '  address public CO_FOUNDER= 0x37805553F1BcAb2CcdBa037B506a6824A17C43Ca;\n', '  address public QR_MINING = 0xA5fa2c9B2290b381f68Dcf7A4C91e906ECea4dF4;\n', '  address public DEV_TEAM  = 0x72B679CEF3dC3092d1b1dfB1C38F24227eBa41d0;\n', '  address public AIR_DROP  = 0x795942F221ac040aa8424ECeCb6E13E342535B40;\n', '  address public COMMUNITY = 0xFC42c43156C0C5A9b704453290656F31f9234619;\n', '\n', '\n', '  function _preMint(address _addr,uint256 _amount) internal{\n', '      balance[_addr] = _amount;\n', '      totalSupply += _amount;\n', '       emit Transfer(address(0),_addr,_amount);\n', '  }\n', '\n', '  constructor() public {\n', '       _preMint(CO_FOUNDER,150000000 ether);\n', '       _preMint(QR_MINING,  90000000 ether);\n', '       _preMint(DEV_TEAM,   15000000 ether);\n', '       _preMint(AIR_DROP,   15000000 ether);\n', '       _preMint(COMMUNITY,  30000000 ether);\n', '     \n', '  }\n', '  \n', '\n', '}']