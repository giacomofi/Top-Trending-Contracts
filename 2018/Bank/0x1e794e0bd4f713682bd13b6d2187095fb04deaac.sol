['pragma solidity ^0.4.24;\n', '\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function withdraw() external;\n', '    function balanceOf(address _customerAddress) view external returns(uint256);\n', '}\n', '\n', 'interface StrongHandsManagerInterface {\n', '    function mint(address _owner, uint256 _amount) external;\n', '}\n', '\n', 'contract StrongHandsManager {\n', '    \n', '    event CreateStrongHand(address indexed owner, address indexed strongHand);\n', '    \n', '    mapping (address => address) public strongHands;\n', '    mapping (address => uint256) public ownerToBalance;\n', '    \n', '    //ERC20\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    \n', '    string public constant name = "Stronghands3D";\n', '    string public constant symbol = "S3D";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    uint256 internal tokenSupply = 0;\n', '\n', '    function getStrong()\n', '        public\n', '    {\n', '        require(strongHands[msg.sender] == address(0), "you already became a Stronghand");\n', '        \n', '        strongHands[msg.sender] = new StrongHand(msg.sender);\n', '        \n', '        emit CreateStrongHand(msg.sender, strongHands[msg.sender]);\n', '    }\n', '    \n', '    function mint(address _owner, uint256 _amount)\n', '        external\n', '    {\n', '        require(strongHands[_owner] == msg.sender);\n', '        \n', '        tokenSupply+= _amount;\n', '        ownerToBalance[_owner]+= _amount;\n', '        \n', '        emit Transfer(address(0), _owner, _amount);\n', '    }\n', '    \n', '    //ERC20\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return tokenSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return ownerToBalance[_owner];\n', '    }\n', '}\n', '\n', 'contract StrongHand {\n', '\n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', '    StrongHandsManagerInterface strongHandManager;\n', '    \n', '    address public owner;\n', '    uint256 private p3dBalance = 0;\n', '    \n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    constructor(address _owner)\n', '        public\n', '    {\n', '        owner = _owner;\n', '        strongHandManager = StrongHandsManagerInterface(msg.sender);\n', '    }\n', '    \n', '    function() public payable {}\n', '   \n', '    function buy(address _referrer)\n', '        external\n', '        payable\n', '        onlyOwner\n', '    {\n', '        purchase(msg.value, _referrer);\n', '    }\n', '    \n', '    function purchase(uint256 _amount, address _referrer)\n', '        private\n', '    {\n', '        p3dContract.buy.value(_amount)(_referrer);\n', '        uint256 balance = p3dContract.balanceOf(address(this));\n', '        \n', '        uint256 diff = balance - p3dBalance;\n', '        p3dBalance = balance;\n', '        \n', '        strongHandManager.mint(owner, diff);\n', '    }\n', '\n', '    function withdraw()\n', '        external\n', '        onlyOwner\n', '    {\n', '        p3dContract.withdraw();\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface HourglassInterface {\n', '    function buy(address _playerAddress) payable external returns(uint256);\n', '    function withdraw() external;\n', '    function balanceOf(address _customerAddress) view external returns(uint256);\n', '}\n', '\n', 'interface StrongHandsManagerInterface {\n', '    function mint(address _owner, uint256 _amount) external;\n', '}\n', '\n', 'contract StrongHandsManager {\n', '    \n', '    event CreateStrongHand(address indexed owner, address indexed strongHand);\n', '    \n', '    mapping (address => address) public strongHands;\n', '    mapping (address => uint256) public ownerToBalance;\n', '    \n', '    //ERC20\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    \n', '    string public constant name = "Stronghands3D";\n', '    string public constant symbol = "S3D";\n', '    uint8 public constant decimals = 18;\n', '    \n', '    uint256 internal tokenSupply = 0;\n', '\n', '    function getStrong()\n', '        public\n', '    {\n', '        require(strongHands[msg.sender] == address(0), "you already became a Stronghand");\n', '        \n', '        strongHands[msg.sender] = new StrongHand(msg.sender);\n', '        \n', '        emit CreateStrongHand(msg.sender, strongHands[msg.sender]);\n', '    }\n', '    \n', '    function mint(address _owner, uint256 _amount)\n', '        external\n', '    {\n', '        require(strongHands[_owner] == msg.sender);\n', '        \n', '        tokenSupply+= _amount;\n', '        ownerToBalance[_owner]+= _amount;\n', '        \n', '        emit Transfer(address(0), _owner, _amount);\n', '    }\n', '    \n', '    //ERC20\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return tokenSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return ownerToBalance[_owner];\n', '    }\n', '}\n', '\n', 'contract StrongHand {\n', '\n', '    HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);\n', '    StrongHandsManagerInterface strongHandManager;\n', '    \n', '    address public owner;\n', '    uint256 private p3dBalance = 0;\n', '    \n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    constructor(address _owner)\n', '        public\n', '    {\n', '        owner = _owner;\n', '        strongHandManager = StrongHandsManagerInterface(msg.sender);\n', '    }\n', '    \n', '    function() public payable {}\n', '   \n', '    function buy(address _referrer)\n', '        external\n', '        payable\n', '        onlyOwner\n', '    {\n', '        purchase(msg.value, _referrer);\n', '    }\n', '    \n', '    function purchase(uint256 _amount, address _referrer)\n', '        private\n', '    {\n', '        p3dContract.buy.value(_amount)(_referrer);\n', '        uint256 balance = p3dContract.balanceOf(address(this));\n', '        \n', '        uint256 diff = balance - p3dBalance;\n', '        p3dBalance = balance;\n', '        \n', '        strongHandManager.mint(owner, diff);\n', '    }\n', '\n', '    function withdraw()\n', '        external\n', '        onlyOwner\n', '    {\n', '        p3dContract.withdraw();\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']
