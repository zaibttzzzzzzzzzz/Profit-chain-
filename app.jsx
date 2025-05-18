import React, { useState } from 'react';
import { ethers } from 'ethers';
import abi from './abi.json'; // Remix se ABI export karein

function App() {
  const [contract, setContract] = useState(null);
  const CONTRACT_ADDRESS = "DEPLOYED_CONTRACT_ADDRESS"; // Polygon par deploy karo

  // Referral link generate karo
  const generateReferralLink = () => {
    return `${window.location.href}?ref=${window.ethereum.selectedAddress}`;
  };

  // Register with referral from URL
  const register = async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const referrer = urlParams.get('ref') || '0x0000000000000000000000000000000000000000';
    await contract.register(referrer);
  };

  // Level upgrade
  const upgradeLevel = async (level) => {
    const fee = await contract.levelFees(level - 1);
    await contract.upgradeLevel(level, { value: fee });
  };

  return (
    <div>
      <h1>Profit Chain</h1>
      <button onClick={() => connectWallet()}>Connect Wallet</button>
      <p>Your Referral Link: {generateReferralLink()}</p>
      <button onClick={register}>Auto-Join via Referral</button>
      <select onChange={(e) => upgradeLevel(e.target.value)}>
        {[1,2,3,4,5,6,7,8,9,10].map((lvl) => (
          <option value={lvl}>Level {lvl}</option>
        ))}
      </select>
    </div>
  );
}

export default App;
