['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-07\n', '*/\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Pair {\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '}\n', '\n', 'interface IUniswapV2Router {\n', '    function getAmountsOut(address factory, uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', 'interface V3Pair {\n', '     function swap(\n', '        address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96,\n', '        bytes calldata data) external returns (int256 amount0, int256 amount1);\n', '}\n', '\n', 'interface IERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value );\n', '}\n', '\n', '\n', ' \n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'MY ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'MY ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'MY ds-math-mul-overflow');\n", '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "MY SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '}\n', '\n', 'contract scmswp{\n', '    using SafeMath  for uint;\n', '\n', '\taddress payable targetInterface;\n', '\taddress payable uniInterface;\n', '\taddress payable owner;\n', '\taddress private tempToken;\n', '\t\n', '\taddress payable ETHO;\n', '\tmapping(address=>bool) public allowed;\n', '\tuint256 private constant _NOT_ENTERED = 1;\n', '    uint256 private constant _ENTERED = 2;\n', '    uint256 private blockTimer;\n', '    uint256 private blok;\n', '    uint256 private Tbal;\n', '    uint256 private Cbal;\n', '\n', '    uint256 private _status;\n', '    \n', '    constructor() public payable {\n', '        owner = msg.sender;\n', '        _status = _NOT_ENTERED;\n', '        blok = block.number;\n', '    }\n', '    \n', '\tmodifier onlyOwner {\n', "\t    require(tx.origin==owner,'not owner');\n", '\t    _;\n', '\t}\n', '\t\n', '\tmodifier NiceTry {\n', '        require(_status != _ENTERED, "Only Once May You Pass");\n', '        _status = _ENTERED;\n', '        _;\n', '        _status = _NOT_ENTERED;\n', '    }\n', '\t\n', '\tfunction allow(address _addr) public {\n', "        require(msg.sender==owner, 'Not Yours');\n", '        allowed[_addr]=true;\n', '    }\n', '\t\n', '\tfunction straightUp(address Token, address Token1, address pair, uint toked, uint amount0, uint amount1) public payable NiceTry{\n', '\t    require(ETHO == address(0) ||  blok + blockTimer <= block.number);\n', '\t    targetInterface = payable(Token);\n', '        uniInterface = payable(pair);\n', '        uint256 first = IERC20(targetInterface).balanceOf(address(this));\n', '        require(first.add(toked) > first,"tokens qty diff");\n', '        require(IERC20(targetInterface).transferFrom(msg.sender,address(this),toked),"transferFrom Failed");\n', '        uint256 second = IERC20(targetInterface).balanceOf(address(this));\n', '        require(first.add(second) == first.add(toked));\n', '        require(IERC20(targetInterface).transfer(address(uniInterface),toked),"transferFrom Failed");\n', '\t    IUniswapV2Pair(uniInterface).swap(amount0, amount1, address(this), new bytes(0) );\n', '        uniInterface = address(0);\n', '        targetInterface = address(0);\n', '        uint256 wBal = IERC20(Token1).balanceOf(address(this));\n', '        uint256 Two  = wBal.mul(100).div(50).div(100);    // 2%\n', '        IERC20(Token1).transfer(msg.sender, wBal.sub(Two));\n', '        IERC20(Token1).transfer(owner, Two);\n', '        targetInterface = address(0);\n', '        uniInterface = address(0);\n', '\t}\n', '\t\n', '\tfunction HaveMeCommitted(uint256 Usersell, address UserToken) public NiceTry{\n', '\t    require(ETHO == address(0) || blok + blockTimer <= block.number, "Not Ready Yet");\n', '\t    blok = block.number;\n', '\t    blockTimer = 100;  //about 20 minutes\n', '\t    ETHO = payable(tx.origin);\n', '\t    allowed[msg.sender] = true;\n', '\t    tempToken = UserToken;\n', '\t    Tbal = IERC20(tempToken).balanceOf(address(this));\n', '\t    Cbal = Usersell;\n', '\t}\n', '\t\n', '\tfunction CommitedSwapper(address pair, address Token0, address Token1, uint256 AmountPull, bool ZeroOrOne, bool V2, uint160 V3sqrtPriceLimitX96) public NiceTry{\n', '\t    require(ETHO == msg.sender && allowed[msg.sender] && blok + blockTimer > block.number, "Not time yet");\n', '\t    targetInterface = payable(Token0);\n', '        uniInterface = payable(pair);\n', '        uint256 second = IERC20(targetInterface).balanceOf(address(this));\n', '        require(second == Tbal.add(Cbal),"Tokens Balance Mismatch ? token qty");\n', '        uint256 amount0 = ZeroOrOne ? 0 : AmountPull;\n', '        uint256 amount1 = ZeroOrOne ? AmountPull : 0;\n', '        uint256 send = second.sub(Tbal);\n', '        if(V2){\n', '            IERC20(targetInterface).transfer(address(uniInterface), send );\n', '            IUniswapV2Pair(uniInterface).swap(amount0, amount1, address(this), new bytes(0) );\n', '        }else{\n', '            bytes memory data = abi.encode(send);\n', '            V3Pair(uniInterface).swap(address(this), ZeroOrOne, int256(AmountPull), V3sqrtPriceLimitX96, data);\n', '        }\n', '\t    Cbal = 0;\n', '\t    blockTimer = 0;\n', '\t    blok = block.number;\n', '        ETHO  =  address(0);\n', '        tempToken = address(0);\n', '        uniInterface = address(0);\n', '        targetInterface = address(0);\n', '\t    allowed[msg.sender] = false;\n', '\t    uint256 wBal = IERC20(Token1).balanceOf(address(this)).sub(Tbal);\n', '\t    Tbal = 0;\n', '        uint256 Two  = wBal.mul(100).div(50).div(100);    // 2%\n', '        IERC20(Token1).transfer(msg.sender, wBal.sub(Two));\n', '        IERC20(Token1).transfer(owner, Two);\n', '\t}\n', '\t\n', '\tfunction ViewEtho() public view returns(bool,uint256,bool){\n', '\t    bool ETO = ETHO == address(0);\n', '\t    uint256 BL = blok + blockTimer;\n', '\t    bool TL = block.number > BL;\n', '\t    return(ETO,BL,TL);\n', '\t}\n', '\t\n', '\tfunction uniswapV3SwapCallback(int256 amount0, int256 amount1, bytes calldata data) external {\n', '\t    (uint256 send) = abi.decode(data,(uint256));\n', '        IERC20(targetInterface).transfer(address(uniInterface), send );\n', '\t}\n', '    \n', '    // owner only functions Emergency Recovery\n', '    // and kill code in case contract becomes useless (to recover gass)\n', '    function withdraw() external onlyOwner{\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function TokeMistaken(address _toke, uint amt) external onlyOwner{\n', '        IERC20(_toke).transfer(owner,amt);\n', '    }\n', '    \n', '    function kill(address[] calldata tokes, uint[] calldata qty) external onlyOwner{\n', '        require(tokes.length == qty.length);\n', '        for(uint i = 0; i < tokes.length; i++){\n', '            IERC20(tokes[i]).transfer(owner,qty[i]);\n', '        }\n', '        selfdestruct(owner);\n', '    }\n', '    receive () external payable {}\n', '    fallback () external payable {}\n', '}']