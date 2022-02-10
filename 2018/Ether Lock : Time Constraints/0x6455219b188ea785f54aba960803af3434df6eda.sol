['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  address public agent; // sale agent\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyAgentOrOwner() {\n', '      require(msg.sender == owner || msg.sender == agent);\n', '      _;\n', '  }\n', '\n', '  function setSaleAgent(address addr) public onlyOwner {\n', '      agent = addr;\n', '  }\n', '  \n', '}\n', '\n', 'contract HeartBoutToken is Ownable {\n', '    function transferTokents(address addr, uint256 tokens) public;\n', '}\n', '\n', 'contract HeartBoutSale is Ownable {\n', '    \n', '    uint32 rate = 10 ** 5;\n', '    \n', '    uint64 public startDate;\n', '    uint64 public endDate;\n', '    uint256 public soldOnCurrentSale = 0;\n', '    \n', '    mapping(string => address) addressByAccountMapping;\n', '\n', '    HeartBoutToken tokenContract;\n', '    \n', '    function HeartBoutSale(HeartBoutToken _tokenContract) public {\n', '        tokenContract = _tokenContract;\n', '    }\n', '    \n', '    function startSale(uint32 _rate, uint64 _startDate, uint64 _endDate) public onlyOwner {\n', '        require(rate != 0);\n', '        require(_rate <= rate);\n', '        require(100 < _rate && _rate < 15000);\n', '        require(_endDate > now);\n', '        require(_startDate < _endDate);\n', '        \n', '        soldOnCurrentSale = 0;\n', '        \n', '        rate = _rate;\n', '        startDate = _startDate;\n', '        endDate = _endDate;\n', '    }\n', '    \n', '    function completeSale() public onlyOwner {\n', '        endDate = 0;\n', '        soldOnCurrentSale = 0;\n', '    }\n', '    \n', '    function () public payable {\n', '        revert();\n', '    }\n', '    \n', '    function buyTokens(string _account) public payable {\n', '        \n', '        require(msg.value > 0);\n', '        require(rate > 0);\n', '        require(endDate > now);\n', '        \n', '        require(msg.value >= (10 ** 16));\n', '        \n', '        uint256 tokens = msg.value * rate;\n', '        \n', '        address _to = msg.sender;\n', '        \n', '        if(addressByAccountMapping[_account] != 0x0) {\n', '            require(addressByAccountMapping[_account] == _to);      \n', '        }\n', '        addressByAccountMapping[_account] = _to;\n', '        \n', '        soldOnCurrentSale += tokens;\n', '\n', '        tokenContract.transferTokents(msg.sender, tokens);\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function getAddressForAccount(string _account) public view returns (address) {\n', '      return addressByAccountMapping[_account];\n', '    }\n', '    \n', '    function stringEqual(string a, string b) internal pure returns (bool) {\n', '      return keccak256(a) == keccak256(b);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '  address public agent; // sale agent\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '  \n', '  modifier onlyAgentOrOwner() {\n', '      require(msg.sender == owner || msg.sender == agent);\n', '      _;\n', '  }\n', '\n', '  function setSaleAgent(address addr) public onlyOwner {\n', '      agent = addr;\n', '  }\n', '  \n', '}\n', '\n', 'contract HeartBoutToken is Ownable {\n', '    function transferTokents(address addr, uint256 tokens) public;\n', '}\n', '\n', 'contract HeartBoutSale is Ownable {\n', '    \n', '    uint32 rate = 10 ** 5;\n', '    \n', '    uint64 public startDate;\n', '    uint64 public endDate;\n', '    uint256 public soldOnCurrentSale = 0;\n', '    \n', '    mapping(string => address) addressByAccountMapping;\n', '\n', '    HeartBoutToken tokenContract;\n', '    \n', '    function HeartBoutSale(HeartBoutToken _tokenContract) public {\n', '        tokenContract = _tokenContract;\n', '    }\n', '    \n', '    function startSale(uint32 _rate, uint64 _startDate, uint64 _endDate) public onlyOwner {\n', '        require(rate != 0);\n', '        require(_rate <= rate);\n', '        require(100 < _rate && _rate < 15000);\n', '        require(_endDate > now);\n', '        require(_startDate < _endDate);\n', '        \n', '        soldOnCurrentSale = 0;\n', '        \n', '        rate = _rate;\n', '        startDate = _startDate;\n', '        endDate = _endDate;\n', '    }\n', '    \n', '    function completeSale() public onlyOwner {\n', '        endDate = 0;\n', '        soldOnCurrentSale = 0;\n', '    }\n', '    \n', '    function () public payable {\n', '        revert();\n', '    }\n', '    \n', '    function buyTokens(string _account) public payable {\n', '        \n', '        require(msg.value > 0);\n', '        require(rate > 0);\n', '        require(endDate > now);\n', '        \n', '        require(msg.value >= (10 ** 16));\n', '        \n', '        uint256 tokens = msg.value * rate;\n', '        \n', '        address _to = msg.sender;\n', '        \n', '        if(addressByAccountMapping[_account] != 0x0) {\n', '            require(addressByAccountMapping[_account] == _to);      \n', '        }\n', '        addressByAccountMapping[_account] = _to;\n', '        \n', '        soldOnCurrentSale += tokens;\n', '\n', '        tokenContract.transferTokents(msg.sender, tokens);\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function getAddressForAccount(string _account) public view returns (address) {\n', '      return addressByAccountMapping[_account];\n', '    }\n', '    \n', '    function stringEqual(string a, string b) internal pure returns (bool) {\n', '      return keccak256(a) == keccak256(b);\n', '    }\n', '}']