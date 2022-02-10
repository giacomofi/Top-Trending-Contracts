['pragma solidity ^0.4.10;\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval (address _spender, uint _addedValue)\n', '    returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue)\n', '    returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract CccTokenIco is StandardToken {\n', '    using SafeMath for uint256;\n', '    string public name = "Crypto Credit Card Token";\n', '    string public symbol = "CCCR";\n', '    uint8 public constant decimals = 6;\n', '    \n', '    uint256 public cntMembers = 0;\n', '    uint256 public totalSupply = 200000000 * (uint256(10) ** decimals);\n', '    uint256 public totalRaised;\n', '\n', '    uint256 public startTimestamp;\n', '    uint256 public durationSeconds = uint256(86400 * 93);//93 days - 15/11/17-16/02/18\n', '\n', '    uint256 public minCap = 3000000 * (uint256(10) ** decimals);\n', '    uint256 public maxCap = 200000000 * (uint256(10) ** decimals);\n', '    \n', '    uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(707);\n', '\n', '    address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;\n', '    address public teama = 0xfc6851324e2901b3ea6170a90Cc43BFe667D617A;\n', '    address public teamb = 0x21f0F5E81BEF4dc696C6BF0196c60a1aC797f953;\n', '    address public teamc = 0xE8726942a46E6C6B3C1F061c14a15c0053A97B6b;\n', '    address public teamd = 0xe388423Bc655543568dd5b454F47AeD2B304710F;\n', '    address public teame = 0xa31B987F467aFF700F322105126619496955f503;\n', '    address public founder = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;\n', '    address public baseowner;\n', '\n', '    event LogTransfer(address sender, address to, uint amount);\n', '    event Clearing(address to, uint256 amount);\n', '\n', '    function CccTokenIco(\n', '    ) \n', '    {\n', '        cntMembers = 0;\n', '        startTimestamp = now - 34 days;//19.12.2017\n', '        baseowner = msg.sender;\n', '        balances[baseowner] = totalSupply;\n', '        Transfer(0x0, baseowner, totalSupply);\n', '\n', '        ///carry out token holders from previous contract instance\n', '        \n', '        balances[baseowner] = balances[baseowner].sub(500003530122);\n', '        balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12] = balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12].add(500003530122);\n', '        Transfer(baseowner, 0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12, 500003530122);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(276000000009);\n', '        balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b] = balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b].add(276000000009);\n', '        Transfer(baseowner, 0xaa00a534093975ac45ecac2365e40b2f81cf554b, 276000000009);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(200000000012);\n', '        balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0] = balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0].add(200000000012);\n', '        Transfer(baseowner, 0xdaeb100e594bec89aa8282d5b0f54e01100559b0, 200000000012);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(31740000001);\n', '        balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2] = balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2].add(31740000001);\n', '        Transfer(baseowner, 0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2, 31740000001);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(27318424808);\n', '        balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb] = balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb].add(27318424808);\n', '        Transfer(baseowner, 0xedfd6f7b43a4e2cdc39975b61965302c47c523cb, 27318424808);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(24130680006);\n', '        balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc] = balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc].add(24130680006);\n', '        Transfer(baseowner, 0x911af73f46c16f0682c707fdc46b3e5a9b756dfc, 24130680006);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(15005580557);\n', '        balances[0x2cec090622838aa3abadd176290dea1bbd506466] = balances[0x2cec090622838aa3abadd176290dea1bbd506466].add(15005580557);\n', '        Transfer(baseowner, 0x2cec090622838aa3abadd176290dea1bbd506466, 15005580557);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(9660000004);\n', '        balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1] = balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1].add(9660000004);\n', '        Transfer(baseowner, 0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1, 9660000004);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(2652719081);\n', '        balances[0xb63a69b443969139766e5734c50b2049297bf335] = balances[0xb63a69b443969139766e5734c50b2049297bf335].add(2652719081);\n', '        Transfer(baseowner, 0xb63a69b443969139766e5734c50b2049297bf335, 2652719081);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(2460000000);\n', '        balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f] = balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f].add(2460000000);\n', '        Transfer(baseowner, 0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f, 2460000000);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(2351000007);\n', '        balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd] = balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd].add(2351000007);\n', '        Transfer(baseowner, 0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd, 2351000007);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(1717313037);\n', '        balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f] = balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f].add(1717313037);\n', '        Transfer(baseowner, 0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f, 1717313037);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(1419509002);\n', '        balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef] = balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef].add(1419509002);\n', '        Transfer(baseowner, 0x5e454499faec83dc1aa65d9f0164fb558f9bfdef, 1419509002);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(1265308761);\n', '        balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b] = balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b].add(1265308761);\n', '        Transfer(baseowner, 0x77d7ab3250f88d577fda9136867a3e9c2f29284b, 1265308761);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(1009138801);\n', '        balances[0x60a1db27141cbab745a66f162e68103f2a4f2205] = balances[0x60a1db27141cbab745a66f162e68103f2a4f2205].add(1009138801);\n', '        Transfer(baseowner, 0x60a1db27141cbab745a66f162e68103f2a4f2205, 1009138801);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(941571961);\n', '        balances[0xab58b3d1866065353bf25dbb813434a216afd99d] = balances[0xab58b3d1866065353bf25dbb813434a216afd99d].add(941571961);\n', '        Transfer(baseowner, 0xab58b3d1866065353bf25dbb813434a216afd99d, 941571961);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(694928265);\n', '        balances[0x8b545e68cf9363e09726e088a3660191eb7152e4] = balances[0x8b545e68cf9363e09726e088a3660191eb7152e4].add(694928265);\n', '        Transfer(baseowner, 0x8b545e68cf9363e09726e088a3660191eb7152e4, 694928265);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(688204065);\n', '        balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e] = balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e].add(688204065);\n', '        Transfer(baseowner, 0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e, 688204065);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(671272463);\n', '        balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17] = balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17].add(671272463);\n', '        Transfer(baseowner, 0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17, 671272463);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(633682839);\n', '        balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4] = balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4].add(633682839);\n', '        Transfer(baseowner, 0xd912f08de16beecab4cc8f1947c119caf6852cf4, 633682839);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(633668277);\n', '        balances[0xdc4b279fd978d248bef6c783c2c937f75855537e] = balances[0xdc4b279fd978d248bef6c783c2c937f75855537e].add(633668277);\n', '        Transfer(baseowner, 0xdc4b279fd978d248bef6c783c2c937f75855537e, 633668277);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(632418818);\n', '        balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a] = balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a].add(632418818);\n', '        Transfer(baseowner, 0x7399a52d49139c9593ea40c11f2f296ca037a18a, 632418818);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(570202760);\n', '        balances[0xbb4691d4dff55fb110f996d029900e930060fe48] = balances[0xbb4691d4dff55fb110f996d029900e930060fe48].add(570202760);\n', '        Transfer(baseowner, 0xbb4691d4dff55fb110f996d029900e930060fe48, 570202760);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(428950000);\n', '        balances[0x826fa4d3b34893e033b6922071b55c1de8074380] = balances[0x826fa4d3b34893e033b6922071b55c1de8074380].add(428950000);\n', '        Transfer(baseowner, 0x826fa4d3b34893e033b6922071b55c1de8074380, 428950000);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(334650000);\n', '        balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de] = balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de].add(334650000);\n', '        Transfer(baseowner, 0x12f3f72fb89f86110d666337c6cb49f3db4b15de, 334650000);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(276000007);\n', '        balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5] = balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5].add(276000007);\n', '        Transfer(baseowner, 0xbb4691d4dff55fb110f996d029900e930060fe48, 276000007);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(181021555);\n', '        balances[0x750b5f444a79895d877a821dfce321a9b00e77b3] = balances[0x750b5f444a79895d877a821dfce321a9b00e77b3].add(181021555);\n', '        Transfer(baseowner, 0x750b5f444a79895d877a821dfce321a9b00e77b3, 181021555);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(143520151);\n', '        balances[0x8d88391bfcb5d3254f82addba383523907e028bc] = balances[0x8d88391bfcb5d3254f82addba383523907e028bc].add(143520151);\n', '        Transfer(baseowner, 0x8d88391bfcb5d3254f82addba383523907e028bc, 143520151);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(131825237);\n', '        balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e] = balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e].add(131825237);\n', '        Transfer(baseowner, 0xf0db27cdabcc02ede5aee9574241a84af930f08e, 131825237);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(99525370);\n', '        balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3] = balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3].add(99525370);\n', '        Transfer(baseowner, 0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3, 99525370);\n', '\n', '\t\t\n', '        balances[baseowner] = balances[baseowner].sub(71712001);\n', '        balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074] = balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074].add(71712001);\n', '        Transfer(baseowner, 0xc19aab396d51f7fa9d8a9c147ed77b681626d074, 71712001);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(69000011);\n', '        balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461] = balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461].add(69000011);\n', '        Transfer(baseowner, 0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461, 69000011);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(55873094);\n', '        balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0] = balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0].add(55873094);\n', '        Transfer(baseowner, 0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0, 55873094);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(42465543);\n', '        balances[0xa404999fa8815c53e03d238f3355dce64d7a533a] = balances[0xa404999fa8815c53e03d238f3355dce64d7a533a].add(42465543);\n', '        Transfer(baseowner, 0xa404999fa8815c53e03d238f3355dce64d7a533a, 42465543);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(40228798);\n', '        balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a] = balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a].add(40228798);\n', '        Transfer(baseowner, 0xdae37bde109b920a41d7451931c0ce7dd824d39a, 40228798);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(27600006);\n', '        balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b] = balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b].add(27600006);\n', '        Transfer(baseowner, 0x6f44062ec1287e4b6890c9df34571109894d2d5b, 27600006);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(26027997);\n', '        balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf] = balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf].add(26027997);\n', '        Transfer(baseowner, 0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf, 26027997);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(13800009);\n', '        balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8] = balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8].add(13800009);\n', '        Transfer(baseowner, 0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8, 13800009);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(13463420);\n', '        balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf] = balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf].add(13463420);\n', '        Transfer(baseowner, 0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf, 13463420);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(2299998);\n', '        balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e] = balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e].add(2299998);\n', '        Transfer(baseowner, 0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e, 2299998);\n', '\n', '        balances[baseowner] = balances[baseowner].sub(1993866);\n', '        balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb] = balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb].add(1993866);\n', '        Transfer(baseowner, 0x74a4d45b8bb857f627229b94cf2b9b74308c61bb, 1993866);\n', '\n', '        cntMembers = cntMembers.add(41);\n', '\n', '    }\n', '\n', '    function bva(address partner, uint256 value, uint256 rate, address adviser) isIcoOpen payable public \n', '    {\n', '      uint256 tokenAmount = calculateTokenAmount(value);\n', '      if(msg.value != 0)\n', '      {\n', '        tokenAmount = calculateTokenCount(msg.value,avgRate);\n', '      }else\n', '      {\n', '        require(msg.sender == stuff);\n', '        avgRate = avgRate.add(rate).div(2);\n', '      }\n', '      if(msg.value != 0)\n', '      {\n', '        Clearing(teama, msg.value.mul(6).div(100));\n', '        teama.transfer(msg.value.mul(6).div(100));\n', '        Clearing(teamb, msg.value.mul(6).div(1000));\n', '        teamb.transfer(msg.value.mul(6).div(1000));\n', '        Clearing(teamc, msg.value.mul(6).div(1000));\n', '        teamc.transfer(msg.value.mul(6).div(1000));\n', '        Clearing(teamd, msg.value.mul(1).div(100));\n', '        teamd.transfer(msg.value.mul(1).div(100));\n', '        Clearing(teame, msg.value.mul(9).div(1000));\n', '        teame.transfer(msg.value.mul(9).div(1000));\n', '        Clearing(stuff, msg.value.mul(9).div(1000));\n', '        stuff.transfer(msg.value.mul(9).div(1000));\n', '        Clearing(founder, msg.value.mul(70).div(100));\n', '        founder.transfer(msg.value.mul(70).div(100));\n', '        if(partner != adviser)\n', '        {\n', '          Clearing(adviser, msg.value.mul(20).div(100));\n', '          adviser.transfer(msg.value.mul(20).div(100));\n', '        }else\n', '        {\n', '          Clearing(founder, msg.value.mul(20).div(100));\n', '          founder.transfer(msg.value.mul(20).div(100));\n', '        } \n', '      }\n', '      totalRaised = totalRaised.add(tokenAmount);\n', '      balances[baseowner] = balances[baseowner].sub(tokenAmount);\n', '      balances[partner] = balances[partner].add(tokenAmount);\n', '      Transfer(baseowner, partner, tokenAmount);\n', '      cntMembers = cntMembers.add(1);\n', '    }\n', '    \n', '    function() isIcoOpen payable public\n', '    {\n', '      if(msg.value != 0)\n', '      {\n', '        uint256 tokenAmount = calculateTokenCount(msg.value,avgRate);\n', '        Clearing(teama, msg.value.mul(6).div(100));\n', '        teama.transfer(msg.value.mul(6).div(100));\n', '        Clearing(teamb, msg.value.mul(6).div(1000));\n', '        teamb.transfer(msg.value.mul(6).div(1000));\n', '        Clearing(teamc, msg.value.mul(6).div(1000));\n', '        teamc.transfer(msg.value.mul(6).div(1000));\n', '        Clearing(teamd, msg.value.mul(1).div(100));\n', '        teamd.transfer(msg.value.mul(1).div(100));\n', '        Clearing(teame, msg.value.mul(9).div(1000));\n', '        teame.transfer(msg.value.mul(9).div(1000));\n', '        Clearing(stuff, msg.value.mul(9).div(1000));\n', '        stuff.transfer(msg.value.mul(9).div(1000));\n', '        Clearing(founder, msg.value.mul(90).div(100));\n', '        founder.transfer(msg.value.mul(90).div(100));\n', '        totalRaised = totalRaised.add(tokenAmount);\n', '        balances[baseowner] = balances[baseowner].sub(tokenAmount);\n', '        balances[msg.sender] = balances[msg.sender].add(tokenAmount);\n', '        Transfer(baseowner, msg.sender, tokenAmount);\n', '        cntMembers = cntMembers.add(1);\n', '      }\n', '    }\n', '\n', '    function calculateTokenAmount(uint256 count) constant returns(uint256) \n', '    {\n', '        uint256 icoDeflator = getIcoDeflator();\n', '        return count.mul(icoDeflator).div(100);\n', '    }\n', '\n', '    function calculateTokenCount(uint256 weiAmount, uint256 rate) constant returns(uint256) \n', '    {\n', '        if(rate==0)revert();\n', '        uint256 icoDeflator = getIcoDeflator();\n', '        return weiAmount.div(rate).mul(icoDeflator).div(100);\n', '    }\n', '\n', '    function getIcoDeflator() constant returns (uint256)\n', '    {\n', '        if (now <= startTimestamp + 14 days)//15.11.2017-29.11.2017 38% \n', '        {\n', '            return 138;\n', '        }else if (now <= startTimestamp + 46 days)//29.11.2017-31.12.2017 23% \n', '        {\n', '            return 123;\n', '        }else if (now <= startTimestamp + 60 days)//01.01.2018-14.01.2018 15% \n', '        {\n', '            return 115;\n', '        }else if (now <= startTimestamp + 74 days)//15.01.2018-28.01.2018\n', '        {\n', '            return 109;\n', '        }else\n', '        {\n', '            return 105;\n', '        }\n', '    }\n', '\n', '    function finalize(uint256 weiAmount) isIcoFinished isStuff payable public\n', '    {\n', '      if(msg.sender == founder)\n', '      {\n', '        founder.transfer(weiAmount);\n', '      }\n', '    }\n', '\n', '    function transfer(address _to, uint _value) isIcoFinished returns (bool) \n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) \n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    modifier isStuff() \n', '    {\n', '        require(msg.sender == stuff || msg.sender == founder);\n', '        _;\n', '    }\n', '\n', '    modifier isIcoOpen() \n', '    {\n', '        require(now >= startTimestamp);//15.11-29.11 pre ICO\n', '        require(now <= startTimestamp + 14 days || now >= startTimestamp + 19 days);//gap 29.11-04.12\n', '        require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);//04.12-02.02 ICO\n', '        require(totalRaised <= maxCap);\n', '        _;\n', '    }\n', '\n', '    modifier isIcoFinished() \n', '    {\n', '        require(now >= startTimestamp);\n', '        require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));\n', '        _;\n', '    }\n', '\n', '}']