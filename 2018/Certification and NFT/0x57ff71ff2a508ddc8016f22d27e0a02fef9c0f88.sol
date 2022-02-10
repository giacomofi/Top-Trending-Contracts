['pragma solidity 0.4.24;\n', '\n', 'contract OCW {\n', '  mapping (uint256 => Mark) public marks;\n', '  string public constant name = "One Crypto World";\n', '  string public constant symbol = "OCW";\n', '  uint8 public constant decimals = 0;\n', '  string public constant memo = "Introducing One Crypto World (OCW)\\n A blockchain is a ledger showing the quantity of something controlled by a user. It enables one to transfer control of that digital representation to someone else.\\nOne Crypto World (OCW) is created and designed by Taiwanese Crypto Congressman Jason Hsu, who is driving for innovative policies in crypto and blockchain. It will be designed as a utility token without the nature of securities. OCW will not go on exchange; users will not be able to make any direct profit through OCW.\\nOne Crypto World is a Proof of Support(POS). The OCW coin will only be distributed to global Key Opinion Leaders (KOLs), which makes it exclusive.\\nBy using OCW coins, each KOL can contribute their valuable opinion to the Crypto Congressman’s policies.";\n', '  \n', '  mapping (address => uint256) private balances;\n', '  mapping (address => uint256) private marked;\n', '  uint256 private totalSupply_ = 1000;\n', '  uint256 private markId = 0;\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '  \n', '  struct Mark {\n', '    address author;\n', '    bytes content;\n', '  }\n', '\n', '  constructor() public {\n', '    balances[msg.sender] = totalSupply_;\n', '  } \n', '  \n', '  function () public {\n', '      mark();\n', '  }\n', '\n', '  function mark() internal {\n', '    require(1 + marked[msg.sender] <= balances[msg.sender]);\n', '    markId ++;\n', '    marked[msg.sender] ++;\n', '    Mark memory temp;\n', '    temp.author = msg.sender;\n', '    temp.content = msg.data;\n', '    marks[markId] = temp;\n', '  }\n', '\n', '  function totalMarks() public view returns (uint256) {\n', '    return markId;\n', '  }\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value + marked[msg.sender] <= balances[msg.sender]);\n', '    require(_value <= balances[msg.sender]);\n', '    require(_value != 0);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender] - _value;\n', '    balances[_to] = balances[_to] + _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}']
['pragma solidity 0.4.24;\n', '\n', 'contract OCW {\n', '  mapping (uint256 => Mark) public marks;\n', '  string public constant name = "One Crypto World";\n', '  string public constant symbol = "OCW";\n', '  uint8 public constant decimals = 0;\n', '  string public constant memo = "Introducing One Crypto World (OCW)\\n A blockchain is a ledger showing the quantity of something controlled by a user. It enables one to transfer control of that digital representation to someone else.\\nOne Crypto World (OCW) is created and designed by Taiwanese Crypto Congressman Jason Hsu, who is driving for innovative policies in crypto and blockchain. It will be designed as a utility token without the nature of securities. OCW will not go on exchange; users will not be able to make any direct profit through OCW.\\nOne Crypto World is a Proof of Support(POS). The OCW coin will only be distributed to global Key Opinion Leaders (KOLs), which makes it exclusive.\\nBy using OCW coins, each KOL can contribute their valuable opinion to the Crypto Congressman’s policies.";\n', '  \n', '  mapping (address => uint256) private balances;\n', '  mapping (address => uint256) private marked;\n', '  uint256 private totalSupply_ = 1000;\n', '  uint256 private markId = 0;\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '  \n', '  struct Mark {\n', '    address author;\n', '    bytes content;\n', '  }\n', '\n', '  constructor() public {\n', '    balances[msg.sender] = totalSupply_;\n', '  } \n', '  \n', '  function () public {\n', '      mark();\n', '  }\n', '\n', '  function mark() internal {\n', '    require(1 + marked[msg.sender] <= balances[msg.sender]);\n', '    markId ++;\n', '    marked[msg.sender] ++;\n', '    Mark memory temp;\n', '    temp.author = msg.sender;\n', '    temp.content = msg.data;\n', '    marks[markId] = temp;\n', '  }\n', '\n', '  function totalMarks() public view returns (uint256) {\n', '    return markId;\n', '  }\n', '  \n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value + marked[msg.sender] <= balances[msg.sender]);\n', '    require(_value <= balances[msg.sender]);\n', '    require(_value != 0);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender] - _value;\n', '    balances[_to] = balances[_to] + _value;\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '}']
