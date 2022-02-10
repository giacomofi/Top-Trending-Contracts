['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract SmartConvas is Owned{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    event paintEvent(address sender, uint x, uint y, uint r, uint g, uint b);\n', '    \n', '    struct Pixel {\n', '        address currentOwner;\n', '        uint r;\n', '        uint g;\n', '        uint b;\n', '        uint currentPrice;\n', '    }\n', '    \n', '    //переменная стоимости пикселя\n', '    uint defaultPrice = 1069120000000000; //1 $ по курсу 937p/eth  in wei\n', '    uint priceInOneEther = 1000000000000000000;\n', '    \n', '    Pixel [1000][1000] pixels;\n', '    \n', '    function getAddress(uint x, uint y) constant returns (address) {\n', '        Pixel memory p = pixels[x][y];\n', '        return p.currentOwner;\n', '    }\n', '    \n', '    function getColor(uint x, uint y) constant returns(uint[3])\n', '    {\n', '        return ([pixels[x][y].r, pixels[x][y].g, pixels[x][y].b]);\n', '    }\n', '    \n', '    function getCurrentPrice(uint x, uint y) constant returns (uint)\n', '    {\n', '        Pixel memory p = pixels[x][y];\n', '        return p.currentPrice;\n', '    }\n', '    \n', '    function addPixelPayable(uint x, uint y, uint r, uint g, uint b) payable  {\n', '\n', '        Pixel memory px = pixels[x][y];\n', '        \n', '        if(msg.value<px.currentPrice)\n', '        {\n', '            revert();\n', '        }\n', '        \n', '\n', '       \n', '        px.r = r;\n', '        px.g = g;\n', '        px.b = b;\n', '        \n', '        if(px.currentOwner>0)\n', '        {\n', '            px.currentOwner.transfer(msg.value.mul(75).div(100));\n', '        }\n', '        \n', '        px.currentOwner = msg.sender;\n', '        if(px.currentPrice ==0)\n', '        {\n', '            px.currentPrice = defaultPrice;\n', '        }\n', '        else\n', '        {\n', '            px.currentPrice = px.currentPrice.mul(2);\n', '        }\n', '        \n', '        pixels[x][y] = px;\n', '        \n', '        emit paintEvent(msg.sender,x,y,r,g,b);\n', '  \n', '    }\n', '    function GetBalance() constant returns (uint)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '    function GetOwner() constant returns (address)\n', '    {\n', '        return owner;\n', '    }\n', '    \n', '    function withdraw() onlyOwner returns(bool) {\n', '        msg.sender.transfer(address(this).balance);\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', ' \n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', ' \n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract SmartConvas is Owned{\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    event paintEvent(address sender, uint x, uint y, uint r, uint g, uint b);\n', '    \n', '    struct Pixel {\n', '        address currentOwner;\n', '        uint r;\n', '        uint g;\n', '        uint b;\n', '        uint currentPrice;\n', '    }\n', '    \n', '    //переменная стоимости пикселя\n', '    uint defaultPrice = 1069120000000000; //1 $ по курсу 937p/eth  in wei\n', '    uint priceInOneEther = 1000000000000000000;\n', '    \n', '    Pixel [1000][1000] pixels;\n', '    \n', '    function getAddress(uint x, uint y) constant returns (address) {\n', '        Pixel memory p = pixels[x][y];\n', '        return p.currentOwner;\n', '    }\n', '    \n', '    function getColor(uint x, uint y) constant returns(uint[3])\n', '    {\n', '        return ([pixels[x][y].r, pixels[x][y].g, pixels[x][y].b]);\n', '    }\n', '    \n', '    function getCurrentPrice(uint x, uint y) constant returns (uint)\n', '    {\n', '        Pixel memory p = pixels[x][y];\n', '        return p.currentPrice;\n', '    }\n', '    \n', '    function addPixelPayable(uint x, uint y, uint r, uint g, uint b) payable  {\n', '\n', '        Pixel memory px = pixels[x][y];\n', '        \n', '        if(msg.value<px.currentPrice)\n', '        {\n', '            revert();\n', '        }\n', '        \n', '\n', '       \n', '        px.r = r;\n', '        px.g = g;\n', '        px.b = b;\n', '        \n', '        if(px.currentOwner>0)\n', '        {\n', '            px.currentOwner.transfer(msg.value.mul(75).div(100));\n', '        }\n', '        \n', '        px.currentOwner = msg.sender;\n', '        if(px.currentPrice ==0)\n', '        {\n', '            px.currentPrice = defaultPrice;\n', '        }\n', '        else\n', '        {\n', '            px.currentPrice = px.currentPrice.mul(2);\n', '        }\n', '        \n', '        pixels[x][y] = px;\n', '        \n', '        emit paintEvent(msg.sender,x,y,r,g,b);\n', '  \n', '    }\n', '    function GetBalance() constant returns (uint)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '    function GetOwner() constant returns (address)\n', '    {\n', '        return owner;\n', '    }\n', '    \n', '    function withdraw() onlyOwner returns(bool) {\n', '        msg.sender.transfer(address(this).balance);\n', '        return true;\n', '    }\n', '}']