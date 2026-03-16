import { FC } from 'react'
import { WaitToggle } from '../waitable/WaitToggle'
import { usePluginStateContext } from '../../hooks/contextHooks';
import { PluginManager } from '../../controllers/PluginManager';
import { useWaiter } from '../../hooks/useWaiter';

export const PluginEnabledToggle: FC<{}> = () => {
    const { data, setData } = usePluginStateContext();
    if (!data) return;

    const checked = data.settings.pluginEnabled !== false;
    const onChange = useWaiter(async (value: boolean) => {
        await PluginManager.updateSettings({ pluginEnabled: value });
        if (value) await PluginManager.start();
        else await PluginManager.killJDSP();
        setData?.(data => data && ({ ...data, settings: { ...data.settings, pluginEnabled: value } }));
    });

    return <WaitToggle label='Enable plugin' checked={checked} onChange={onChange} />;
}
