['pragma solidity ^0.4.24;\n', '\n', 'contract Left {\n', '  string public name;\n', '  string public symbol;\n', '  uint8 public decimals;\n', '  uint256 public totalSupply;\n', '  mapping (address => uint256) public balanceOf;\n', '\n', '  string public author;\n', '  uint256 internal PPT;\n', '\n', '  uint public voteSession;\n', '  uint256 public pennyRate;\n', '\n', '  mapping (uint => mapping (bool => uint256)) public upVote;\n', '  mapping (address => mapping (uint => mapping (bool => uint256))) public votes;\n', '\n', '  address constant PROJECT = 0x537ca62B4c232af1ef82294BE771B824cCc078Ff;\n', '  address constant UPVOTE = 0xaf6F22ccB2358857fa31F0B393482a81280B92A5;\n', '  address constant DOWNVOTE = 0x0F64C8026569413747a235fBdDb1F25464077BB3;\n', '\n', '  event Transfer (address indexed from, address indexed to, uint256 value);\n', '\n', '  constructor () public {\n', '    author = "ASINERUM INTERNATIONAL";\n', '    name = "ETHEREUM VOTABLE TOKEN 2";\n', '    symbol = "LEFT";\n', '    decimals = 18;\n', '    PPT = 10**18;\n', '    pennyRate = PPT;\n', '  }\n', '\n', '  function w2p (uint256 value)\n', '  internal view returns (uint256) {\n', '    return value*pennyRate/PPT;\n', '  }\n', '\n', '  function p2w (uint256 value)\n', '  internal view returns (uint256) {\n', '    return value*PPT/pennyRate;\n', '  }\n', '\n', '  function adjust ()\n', '  internal {\n', '    if (upVote[voteSession][true]>totalSupply/2) {\n', '      pennyRate = pennyRate*(100+2)/100;\n', '      voteSession += 1;\n', '    } else if (upVote[voteSession][false]>totalSupply/2) {\n', '      pennyRate = pennyRate*(100-2)/100;\n', '      voteSession += 1;\n', '    }\n', '  }\n', '\n', '  function adjust (address from, uint256 value, bool add)\n', '  internal {\n', '    if (add) balanceOf[from] += value;\n', '    else balanceOf[from] -= value;\n', '    if (votes[from][voteSession][true]>0) {\n', '      upVote[voteSession][true] =\n', '      upVote[voteSession][true] - votes[from][voteSession][true] + balanceOf[from];\n', '      votes[from][voteSession][true] = balanceOf[from];\n', '    } else if (votes[from][voteSession][false]>0) {\n', '      upVote[voteSession][false] =\n', '      upVote[voteSession][false] - votes[from][voteSession][false] + balanceOf[from];\n', '      votes[from][voteSession][false] = balanceOf[from];\n', '    }\n', '    adjust ();\n', '  }\n', '\n', '  function move (address from, address to, uint256 value)\n', '  internal {\n', '    require (value<=balanceOf[from]);\n', '    require (balanceOf[to]+value>balanceOf[to]);\n', '    uint256 sum = balanceOf[from]+balanceOf[to];\n', '    adjust (from, value, false);\n', '    adjust (to, value, true);\n', '    assert (balanceOf[from]+balanceOf[to]==sum);\n', '    emit Transfer (from, to, value);\n', '  }\n', '\n', '  function mint (address to, uint256 value)\n', '  internal {\n', '    require (balanceOf[to]+value>balanceOf[to]);\n', '    uint256 dif = totalSupply-balanceOf[to];\n', '    totalSupply += value;\n', '    adjust (to, value, true);\n', '    assert (totalSupply-balanceOf[to]==dif);\n', '  }\n', '\n', '  function burn (address from, uint256 value)\n', '  internal {\n', '    require (value<=balanceOf[from]);\n', '    uint256 dif = totalSupply-balanceOf[from];\n', '    totalSupply -= value;\n', '    adjust (from, value, false);\n', '    assert (totalSupply-balanceOf[from]==dif);\n', '  }\n', '\n', '  function () public payable {\n', '    download ();\n', '  }\n', '\n', '  function download () public payable returns (bool success) {\n', '    require (msg.value>0, "#input");\n', '    mint (msg.sender, w2p(msg.value));\n', '    mint (PROJECT, msg.value/1000);\n', '    return true;\n', '  }\n', '\n', '  function upload (uint256 value) public returns (bool success) {\n', '    require (value>0, "#input");\n', '    burn (msg.sender, value);\n', '    msg.sender.transfer (p2w(value));\n', '    return true;\n', '  }\n', '\n', '  function clear () public returns (bool success) {\n', '    require (balanceOf[msg.sender]>0, "#balance");\n', '    if (p2w(balanceOf[msg.sender])<=address(this).balance) upload (balanceOf[msg.sender]);\n', '    else upload (w2p(address(this).balance));\n', '    return true;\n', '  }\n', '\n', '  function burn (uint256 value) public returns (bool success) {\n', '    burn (msg.sender, value);\n', '    return true;\n', '  }\n', '\n', '  function transfer (address to, uint256 value) public returns (bool success) {\n', '    if (to==address(this)) upload (value);\n', '    else if (to==UPVOTE) vote (true);\n', '    else if (to==DOWNVOTE) vote (false);\n', '    else move (msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  function vote (bool upvote) public returns (bool success) {\n', '    require (balanceOf[msg.sender]>0);\n', '    upVote[voteSession][upvote] =\n', '    upVote[voteSession][upvote] - votes[msg.sender][voteSession][upvote] + balanceOf[msg.sender];\n', '    votes[msg.sender][voteSession][upvote] = balanceOf[msg.sender];\n', '    if (votes[msg.sender][voteSession][!upvote]>0) {\n', '      upVote[voteSession][!upvote] =\n', '      upVote[voteSession][!upvote] - votes[msg.sender][voteSession][!upvote];\n', '      votes[msg.sender][voteSession][!upvote] = 0;\n', '    }\n', '    adjust ();\n', '    return true;\n', '  }\n', '\n', '  function status (address ua) public view returns (\n', '  uint256 rate,\n', '  uint256 supply,\n', '  uint256 ethFund,\n', '  uint256[2] allVotes,\n', '  uint256[2] userVotes,\n', '  uint256[2] userFund) {\n', '    rate = pennyRate;\n', '    supply = totalSupply;\n', '    ethFund = address(this).balance;\n', '    allVotes[0] = upVote[voteSession][true];\n', '    allVotes[1] = upVote[voteSession][false];\n', '    userVotes[0] = votes[ua][voteSession][true];\n', '    userVotes[1] = votes[ua][voteSession][false];\n', '    userFund[0] = address(ua).balance;\n', '    userFund[1] = balanceOf[address(ua)];\n', '  }\n', '\n', '  // MARKETPLACE\n', '\n', '  mapping (uint => Market) public markets;\n', '  struct Market {\n', '    bool buytoken;\n', '    address maker;\n', '    uint256 value;\n', '    uint256 ppe;\n', '    uint time; }\n', '\n', '  event Sale (uint refno, bool indexed buy, address indexed maker, uint256 indexed ppe, uint time);\n', '  event Get (uint indexed refno, address indexed taker, uint256 value); //<Sale>\n', '\n', '  function ethered (uint256 value)\n', '  internal view returns (bool) {\n', '    require (msg.value*value==0&&msg.value+value>0, "#values");\n', '    require (value<=totalSupply, "#value");\n', '    return msg.value>0?true:false;\n', '  }\n', '\n', '  function post (uint refno, uint256 value, uint256 ppe, uint time) public payable returns (bool success) {\n', '    require (markets[refno].maker==0x0, "#refno");\n', '    require (ppe>0&&ppe<totalSupply, "#rate");\n', '    require (time==0||time>now, "#time");\n', '    Market memory mi;\n', '    mi.buytoken = ethered (value);\n', '    mi.value = msg.value+value;\n', '    mi.maker = msg.sender;\n', '    mi.time = time;\n', '    mi.ppe = ppe;\n', '    markets[refno] = mi;\n', '    if (!mi.buytoken) move (msg.sender, address(this), value);\n', '    emit Sale (refno, mi.buytoken, mi.maker, mi.ppe, mi.time);\n', '    return true;\n', '  }\n', '\n', '  function unpost (uint refno) public returns (bool success) {\n', '    Market storage mi = markets[refno];\n', '    require (mi.value>0, "#data");\n', '    require (mi.maker==msg.sender, "#user");\n', '    require (mi.time==0||mi.time<now, "#time");\n', '    if (mi.buytoken) mi.maker.transfer (mi.value);\n', '    else move (address(this), mi.maker, mi.value);\n', '    mi.value = 0;\n', '    return true;\n', '  }\n', '\n', '  function acquire (uint refno, uint256 value) public payable returns (bool success) {\n', '    bool buytoken = ethered (value);\n', '    Market storage mi = markets[refno];\n', '    require (mi.maker!=0x0, "#refno");\n', '    require (mi.value>0&&mi.ppe>0, "#data");\n', '    require (mi.time==0||mi.time>=now, "#time");\n', '    require (mi.buytoken==!buytoken, "#request");\n', '    uint256 pre = mi.value;\n', '    uint256 remit;\n', '    if (buytoken) {\n', '      remit = msg.value*mi.ppe/PPT;\n', '      require (remit>0&&remit<=mi.value, "#volume");\n', '      move (address(this), msg.sender, remit);\n', '      mi.maker.transfer (msg.value);\n', '    } else {\n', '      remit = value*PPT/mi.ppe;\n', '      require (remit>0&&remit<=mi.value, "#volume");\n', '      move (msg.sender, mi.maker, value);\n', '      msg.sender.transfer (remit);\n', '    }\n', '    mi.value -= remit;\n', '    assert (mi.value+remit==pre);\n', '    emit Get (refno, msg.sender, remit);\n', '    return true;\n', '  }\n', '}']