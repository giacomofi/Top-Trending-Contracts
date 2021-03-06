['pragma solidity 0.4.18;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IMaker {\n', '    function sai() public view returns (ERC20);\n', '    function skr() public view returns (ERC20);\n', '    function gem() public view returns (ERC20);\n', '\n', '    function open() public returns (bytes32 cup);\n', '    function give(bytes32 cup, address guy) public;\n', '\n', '    function ask(uint wad) public view returns (uint);\n', '\n', '    function join(uint wad) public;\n', '    function lock(bytes32 cup, uint wad) public;\n', '    function free(bytes32 cup, uint wad) public;\n', '    function draw(bytes32 cup, uint wad) public;\n', '    function cage(uint fit_, uint jam) public;\n', '}\n', '\n', 'interface IWETH {\n', '    function deposit() public payable;\n', '    function withdraw(uint wad) public;\n', '}\n', '\n', '\n', 'contract DaiMaker {\n', '    IMaker public maker;\n', '    ERC20 public weth;\n', '    ERC20 public peth;\n', '    ERC20 public dai;\n', '\n', '    event MakeDai(address indexed daiOwner, address indexed cdpOwner, uint256 ethAmount, uint256 daiAmount);\n', '\n', '    function DaiMaker(IMaker _maker) {\n', '        maker = _maker;\n', '        weth = maker.gem();\n', '        peth = maker.skr();\n', '        dai = maker.sai();\n', '    }\n', '\n', '    function makeDai(uint256 daiAmount, address cdpOwner, address daiOwner) payable public returns (bytes32 cdpId) {\n', '        IWETH(weth).deposit.value(msg.value)();     // wrap eth in weth token\n', '        weth.approve(maker, msg.value);             // allow maker to pull weth\n', '\n', '        maker.join(maker.ask(msg.value));           // convert weth to peth\n', '        uint256 pethAmount = peth.balanceOf(this);\n', '        peth.approve(maker, pethAmount);            // allow maker to pull peth\n', '\n', '        cdpId = maker.open();                       // create cdp in maker\n', '        maker.lock(cdpId, pethAmount);              // lock peth into cdp\n', '        maker.draw(cdpId, daiAmount);               // create dai from cdp\n', '\n', '        dai.transfer(daiOwner, daiAmount);          // transfer dai to owner\n', '        maker.give(cdpId, cdpOwner);                // transfer cdp to owner\n', '\n', '        MakeDai(daiOwner, cdpOwner, msg.value, daiAmount);\n', '    }\n', '}']