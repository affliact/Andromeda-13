import { Dropdown, NumberInput, Stack } from 'tgui-core/components';

import { Feature, FeatureNumericData, FeatureValueProps } from '../base';

type FpsServerData = FeatureNumericData & {
  recommended_fps: number;
};

function FpsInput(props: FeatureValueProps<number, number, FpsServerData>) {
  const { handleSetValue, serverData } = props;

  let recommened = `Рекомендованно`;
  if (serverData) {
    recommened += ` (${serverData.recommended_fps})`;
  }

  return (
    <Stack fill>
      <Stack.Item basis="70%">
        <Dropdown
          selected={props.value === -1 ? recommened : 'Пользовательский'}
          onSelected={(value) => {
            if (value === recommened) {
              handleSetValue(-1);
            } else {
              handleSetValue(serverData?.recommended_fps || 60);
            }
          }}
          width="100%"
          options={[recommened, 'Пользовательский']}
        />
      </Stack.Item>

      <Stack.Item>
        {serverData && props.value !== -1 && (
          <NumberInput
            onChange={(value) => {
              props.handleSetValue(value);
            }}
            minValue={1}
            maxValue={serverData.maximum}
            value={props.value}
            step={1}
          />
        )}
      </Stack.Item>
    </Stack>
  );
}

export const clientfps: Feature<number, number, FpsServerData> = {
  name: 'FPS',
  category: 'ГЕЙМПЛЕЙ',
  component: FpsInput,
};
