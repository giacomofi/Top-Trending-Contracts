['pragma solidity ^0.4.24;\n', '\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint);\n', '\n', '    function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool ok);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '\n', '    function approve(address spender, uint value) public returns (bool ok);\n', '\n', '    function mintToken(address to, uint256 value) public returns (uint256);\n', '\n', '    function changeTransfer(bool allowed) public;\n', '}\n', '\n', 'contract SaleCandle {\n', '    address public creator;\n', '\n', '    uint256 private totalMinted;\n', '\n', '    ERC20 public Candle;\n', '    uint256 public candleCost;\n', '\n', '    uint256 public minCost;\n', '    uint256 public maxCost;\n', '\n', '    address public FOG;//25%\n', '    address public SUN;//25%\n', '    address public GOD;//40%\n', '    address public APP;//10%\n', '\n', '    event Contribution(address from, uint256 amount);\n', '\n', '    constructor() public {\n', '        creator = msg.sender;\n', '        totalMinted = 0;\n', '    }\n', '\n', '    function changeCreator(address _creator) external {\n', '        require(msg.sender == creator);\n', '        creator = _creator;\n', '    }\n', '\n', '    function changeParams(address _candle, uint256 _candleCost, address _fog, address _sun, address _god, address _app) external {\n', '        require(msg.sender == creator);\n', '\n', '        Candle = ERC20(_candle);\n', '        candleCost = _candleCost;\n', '\n', '        minCost=fromPercentage(_candleCost, 97);\n', '        maxCost=fromPercentage(_candleCost, 103);\n', '\n', '        FOG = _fog;\n', '        SUN = _sun;\n', '        GOD = _god;\n', '        APP = _app;\n', '    }\n', '\n', '    function getTotalMinted() public constant returns (uint256) {\n', '        require(msg.sender == creator);\n', '        return totalMinted;\n', '    }\n', '\n', '    function() public payable {\n', '        require(msg.value > 0);\n', '        require(msg.value >= minCost);\n', '\n', '        uint256 forProcess = 0;\n', '        uint256 forReturn = 0;\n', '        if(msg.value>maxCost){\n', '            forProcess = maxCost;\n', '            forReturn = msg.value - maxCost;\n', '        }else{\n', '            forProcess = msg.value;\n', '        }\n', '\n', '        totalMinted += 1;\n', '\n', '        uint256 forFog = fromPercentage(forProcess, 25);\n', '        uint256 forSun = fromPercentage(forProcess, 25);\n', '        uint256 forGod = fromPercentage(forProcess, 40);\n', '        uint256 forApp = forProcess - (forFog+forSun+forGod);\n', '\n', '        APP.transfer(forApp);\n', '        GOD.transfer(forGod);\n', '        SUN.transfer(forSun);\n', '        FOG.transfer(forFog);\n', '\n', '        if(forReturn>0){\n', '            msg.sender.transfer(forReturn);\n', '        }\n', '\n', '        Candle.mintToken(msg.sender, 1);\n', '        emit Contribution(msg.sender, 1);\n', '    }\n', '\n', '    function fromPercentage(uint256 value, uint256 percentage) internal returns (uint256) {\n', '        return (value * percentage) / 100;\n', '    }\n', '}']