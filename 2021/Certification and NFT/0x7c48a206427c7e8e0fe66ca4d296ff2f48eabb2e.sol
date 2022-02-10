['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-23\n', '*/\n', '\n', 'pragma solidity = 0.6.12;\n', '\n', 'interface IERC20 {\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function approve(address spender, uint value) external returns (bool);\n', '}\n', '\n', 'interface IrouteU {\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '}\n', '\n', 'contract LQBR{\n', '    \n', '    address payable owner;\n', '    mapping(address=>bool) public allowed;\n', '    \n', '    constructor()public{\n', '        owner = msg.sender;\n', '        allowed[owner] = true;\n', '        allowed[address(this)] = true;\n', '    }\n', '    \n', '    modifier onlyOwner {\n', "\t    require(tx.origin==owner,'not owner');\n", '\t    _;\n', '\t}\n', '\t\n', '    modifier Pass {\n', '        require(allowed[tx.origin] == true);\n', '        _;\n', '    }\n', '    \n', '    function GivePerms(address user, bool allowing) public onlyOwner {\n', '        allowed[user] = allowing;\n', '    }\n', '    \n', '    function BurnIt(address pair, address Token1, uint256 amount) public Pass{\n', '        pair.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",owner,pair,amount));\n', '        (bool Success, bytes memory data) = pair.call(abi.encodeWithSignature("burn(address)",address(this)));\n', '        (, uint256 am1) = abi.decode(data,(uint256,uint256));\n', '        require(Success && am1 > 0, "weth didn\'t come");\n', '        uint256 two = IERC20(Token1).balanceOf(address(this)) * 200 / 10000;\n', '        Token1.call(abi.encodeWithSignature("transfer(address,uint256)",0xeCf3abd1a9bd55d06768dde7DEef3FD2A48c8e13,two));\n', '        (bool Sucess,) = Token1.call(abi.encodeWithSignature("transfer(address,uint256)",owner,IERC20(Token1).balanceOf(address(this))));\n', '        require(Sucess, "something is broke");\n', '    }\n', '    \n', '    function SellIt(address TokenAddress, address pair, uint256 amountTrans, uint256 amount0Out, uint256 amount1Out) public Pass{\n', '        TokenAddress.call(abi.encodeWithSignature("transfer(address,uint256)",pair,amountTrans));\n', '        IrouteU(pair).swap(amount0Out, amount1Out, owner, new bytes(0));\n', '\n', '    }\n', '    \n', '     // owner only functions Emergency Recovery\n', '    // and kill code in case contract becomes useless (to recover gass)\n', '    function withdraw() external onlyOwner{\n', '        owner.transfer(address(this).balance);\n', '    }\n', '    \n', '    function WithDraw(address _toke, address spender, uint amt) external onlyOwner{\n', '        IERC20(_toke).transfer(spender,amt);\n', '    }\n', '    \n', '    function kill(address[] calldata tokes, uint[] calldata qty) external onlyOwner{\n', '        require(tokes.length == qty.length);\n', '        for(uint i = 0; i < tokes.length; i++){\n', '            IERC20(tokes[i]).transfer(owner,qty[i]);\n', '        }\n', '        selfdestruct(owner);\n', '    }\n', '    receive () external payable {}\n', '    fallback () external payable {}\n', '}']