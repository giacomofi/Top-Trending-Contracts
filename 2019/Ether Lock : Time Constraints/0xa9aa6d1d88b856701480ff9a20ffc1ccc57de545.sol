['pragma solidity 0.5.4;\n', '\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '    return c;\n', '  }\n', '\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract LockTokenContract {\n', '    using SafeMath for uint;\n', ' \n', '    uint256[] public FoundationReleaseStage = [\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        283333333,\n', '        566666666,\n', '        850000000,\n', '        1133333333,\n', '        1416666666,\n', '        1700000000,\n', '        1983333333,\n', '        2266666666,\n', '        2550000000,\n', '        2833333333,\n', '        3116666666,\n', '        3400000000\n', '    ];\n', '    \n', '    uint256[] public TeamAndAdviserAddreesOneStage = [\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        3000000,\n', '        6000000,\n', '        9000000,\n', '        12000000,\n', '        15000000,\n', '        18000000,\n', '        21000000,\n', '        24000000,\n', '        27000000,\n', '        30000000,\n', '        33000000,\n', '        36000000,\n', '        39000000,\n', '        42000000,\n', '        45000000,\n', '        48000000,\n', '        51000000,\n', '        54000000,\n', '        57000000,\n', '        60000000,\n', '        63000000,\n', '        66000000,\n', '        69000000,\n', '        72000000,\n', '        75000000,\n', '        78000000,\n', '        81000000,\n', '        84000000,\n', '        87000000,\n', '        90000000,\n', '        93000000,\n', '        96000000,\n', '        300000000\n', '    ];\n', '    \n', '    uint256[] public TeamAndAdviserAddreesTwoStage = [\n', '        0,\n', '        0,\n', '        0,\n', '        0,\n', '        7000000,\n', '        14000000,\n', '        21000000,\n', '        28000000,\n', '        35000000,\n', '        42000000,\n', '        49000000,\n', '        56000000,\n', '        63000000,\n', '        70000000,\n', '        77000000,\n', '        84000000,\n', '        91000000,\n', '        98000000,\n', '        105000000,\n', '        112000000,\n', '        119000000,\n', '        126000000,\n', '        133000000,\n', '        140000000,\n', '        147000000,\n', '        154000000,\n', '        161000000,\n', '        168000000,\n', '        175000000,\n', '        182000000,\n', '        189000000,\n', '        196000000,\n', '        203000000,\n', '        210000000,\n', '        217000000,\n', '        224000000,\n', '        1300000000\n', '    ];\n', '    \n', '    \n', '    address public FoundationAddress = address(0x98d7cbfF0E5d6807F00A7047FdcdBDb7B1192f57);\n', '    address public TeamAndAdviserAddreesOne = address(0xb89b941F7cd9eBCBcAc16cA2F03aace5cf8e2edc);\n', '    address public TeamAndAdviserAddreesTwo = address(0x5a403e651EC2cD3b6B385dC639f1A90ea01017f7);\n', '    address public GubiTokenAddress  = address(0x12b2B2331A72d375c453c160B2c8A7010EeA510A);\n', '    \n', '    \n', '    uint public constant StageSection  = 5; // 5s\n', '    uint public StartTime = now; // 现在\n', '    \n', '    mapping(address => uint256) AddressWithdrawals;\n', '\n', '\n', '    constructor() public {\n', '    }\n', '\n', '\n', '    function () payable external {\n', '        require(msg.sender == FoundationAddress || msg.sender == TeamAndAdviserAddreesOne || msg.sender == TeamAndAdviserAddreesTwo );\n', '        require(msg.value == 0);\n', '        require(now > StartTime);\n', '\n', '        Token token = Token(GubiTokenAddress);\n', '        uint balance = token.balanceOf(address(this));\n', '        require(balance > 0);\n', '\n', '        uint256[] memory stage;\n', '        if (msg.sender == FoundationAddress) {\n', '            stage = FoundationReleaseStage;\n', '        } else if (msg.sender == TeamAndAdviserAddreesOne) {\n', '            stage = TeamAndAdviserAddreesOneStage;\n', '        } else if (msg.sender == TeamAndAdviserAddreesTwo) {\n', '            stage = TeamAndAdviserAddreesTwoStage;\n', '        }\n', '        uint amount = calculateUnlockAmount(now, balance, stage);\n', '        if (amount > 0) {\n', '            AddressWithdrawals[msg.sender] = AddressWithdrawals[msg.sender].add(amount);\n', '\n', '            require(token.transfer(msg.sender, amount.mul(1e18)));\n', '        }\n', '    }\n', '\n', '    function calculateUnlockAmount(uint _now, uint _balance, uint256[] memory stage) internal view returns (uint amount) {\n', '        uint phase = _now\n', '            .sub(StartTime)\n', '            .div(StageSection);\n', '            \n', '        if (phase >= stage.length) {\n', '            phase = stage.length - 1;\n', '        }\n', '        \n', '        uint256 unlockable = stage[phase]\n', '            .sub(AddressWithdrawals[msg.sender]);\n', '\n', '        if (unlockable == 0) {\n', '            return 0;\n', '        }\n', '\n', '        if (unlockable > _balance.div(1e18)) {\n', '            return _balance.div(1e18);\n', '        }\n', '        \n', '        return unlockable;\n', '    }\n', '}']